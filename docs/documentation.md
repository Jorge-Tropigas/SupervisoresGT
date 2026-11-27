# 🏛️ Documentación de Arquitectura y Análisis — Tropi Supervisores (`app-supervisores-android`)

> Guía técnica del proyecto, elaborada por ingeniería inversa exhaustiva del código fuente actual.
> Ruta: `Apps_Antiguas_mejorarlas_API37/app-supervisores-android`
> `applicationId`: `com.tomzagroup.tropisupervisores` · `rootProject.name`: `Tropi Supervisores` · Versión `1.0.2` (`versionCode 4`).
> Fecha de análisis: 2026-10-06.

---

## 0. Resumen Ejecutivo

Aplicación Android **nativa** (Kotlin) para **supervisores y gerentes de Tropigas Guatemala**. Gestiona el ciclo operativo de puntos de venta y visitas: login con validación de IMEI, dashboard de metas, tiendas asignadas, preventa (cortes de ruta), programación de visitas, checklist de visita, incidencias con fotografías, inventario, autorizaciones de corte, firma digital y **impresión térmica Bluetooth Bixolon**.

- **Arquitectura:** MVVM en capas (UI → ViewModel → Repository → Service/DAO), con **Hilt** para inyección de dependencias, **Retrofit/OkHttp** para red, **Room** para persistencia local, **Navigation Component** (single-activity + fragments) y **Firebase Crashlytics + Analytics**.
- **Tipo de proyecto:** Gradle independiente de un solo módulo `:app` (no monorepo).
- **Estado:** funcional en QA. Todos los entornos (debug **y** release) apuntan a `https://pruebasgenesys.tomzagroup.com/`; **release no está configurado a producción** (ver §6).
- **Trabajo reciente documentado** (`.artifacts/`): cumplimiento de Foreground Services en Android 14+, impresión en hilo IO y corrección de race-condition al imprimir.

---

## 1. Arquitectura y Stack Tecnológico

### 1.1 Stack y versiones

| Componente | Versión / Detalle |
|---|---|
| Lenguaje | Kotlin `1.9.24` (JVM target **21**) |
| Android Gradle Plugin | `8.5.2` · Gradle Wrapper `8.11.x` |
| `compileSdk` / `targetSdk` | **37** |
| `minSdk` | **21** |
| Build features | `viewBinding = true`, `buildConfig = true`, `coreLibraryDesugaring` (`desugar_jdk_libs 2.0.4`) |
| DI | Dagger **Hilt 2.51.1** (`kapt`) |
| Red | Retrofit `2.9.0` + `converter-gson` + OkHttp `logging-interceptor 4.9.0` (solo `Protocol.HTTP_1_1`) |
| Persistencia | Room `2.6.1` (`kapt`) + `SharedPreferences` |
| Navegación | Navigation Component `2.5.3` (fragments `-ktx`, ui `-ktx`) + safe-args `2.7.7` |
| Async | Coroutines `1.4.1` (`core`/`android`) |
| UI | Material `1.12.0`, ConstraintLayout `2.0.4`, ViewBinding, Lottie `3.6.1`, animaciones |
| Gráficas | MPAndroidChart `v3.1.0`; `circularprogressbar 3.1.0`; `round-corner-progress-bar 2.2.1` |
| Imágenes | Glide `4.16.0` (`kapt`) |
| Ubicación | `play-services-location 18.0.0` (FusedLocationProviderClient) |
| Permisos | EasyPermissions `3.0.0` |
| Firebase | BoM `27.0.0` (Crashlytics + Analytics) + `google-services 4.4.2` |
| Impresión | SDK **Bixolon** vendido en `app/libs` (`bixolon_printer_V2.2.10.jar`, `libcommon_V1.4.4.jar`, `pdf/bixolon_pdf.aar`) + `jniLibs` (`libbxl_common.so` para arm64-v8a, armeabi-v7a, x86, x86_64) |
| Test | JUnit `4.13.2`, AndroidX Test JUnit `1.1.5`, Espresso `3.5.1` |

> Observación de compilación: `kapt` y `gradle.properties` inyectan flags `--add-exports=jdk.compiler/...` porque **JDK 21 + kapt + Kotlin 1.9.24** requieren abrir módulos internos del compilador. El `AndroidManifest` declara `FOREGROUND_SERVICE_LOCATION` y `FOREGROUND_SERVICE_CONNECTED_DEVICE` (requisito Android 14+).

### 1.2 Estructura de directorios (completa, fuente real)

```
app-supervisores-android/
├── build.gradle                     # buildscript: AGP 8.5.2, Kotlin 1.9.24, safe-args 2.7.7, Hilt, google-services, crashlytics
├── settings.gradle                  # include ':app'; rootProject.name = "Tropi Supervisores"
├── gradle.properties                # AndroidX, jetifier, jvmargs -Xmx2048m + add-exports
├── gradlew / gradlew.bat
├── gradle/wrapper/gradle-wrapper.*
├── local.properties                 # sdk.dir (ruta local de Android SDK)
├── apk/                             # ⚠️ artefactos de firma + doc de datos
│   ├── Datos Tropi Supervisores.docx
│   ├── private_key.pepk
│   ├── TropiSupervisoresKeyStore.jks
│   └── TropiSupervisoresKeyStore.p12
├── .artifacts/e43a5630-.../         # planes y walkthrough de fixes recientes
│   ├── implementation_plan.artifact.md
│   ├── task.artifact.md
│   └── walkthrough.artifact.md
└── app/
    ├── build.gradle
    ├── google-services.json         # config Firebase del proyecto
    ├── proguard-rules.pro
    ├── libs/                        # jars/aar/so del SDK Bixolon
    └── src/
        ├── main/
        │   ├── AndroidManifest.xml
        │   ├── assets/              # Lottie (*.json) + fuentes OpenSans-*.ttf
        │   ├── java/com/tomzagroup/tropisupervisores/     (ver §3)
        │   ├── jniLibs/             # libbxl_common.so (4 ABIs)
        │   └── res/                 # layouts, menus, navigation, drawables, values, xml
        ├── test/java/.../ExampleUnitTest.kt
        └── androidTest/java/.../ExampleInstrumentedTest.kt
```

### 1.3 Capas y patrón

```
ui/activities · ui/fragments · ui/dialogs   ← ViewBinding + LiveData observers
                 │  (viewModels() / Hilt @HiltViewModel)
                 ▼
ui/**/XxxViewModel   (AndroidViewModel + viewModelScope)   → expone MutableLiveData<Resource<T>>
                 │
                 ▼
ui/**/XxxRepository  (@Inject constructor)                 → suspend fun (Response<T>)
                 │
        ┌────────┴─────────┐
        ▼                  ▼
data/remote/         data/local/
SupervisoresService  Room DAOs
(Retrofit interface) (Imei, Usuario, Fotografia)
```

- **`core/Resource.kt`**: `sealed class Resource<T>` (`Success`/`Error`/`Loading`).
- **`core/LocationResource.kt`**: variante con `Nothing` para el servicio de ubicación.
- **`core/RetrofitHandleCall.kt`**: `handleCallResponse()` convierte `Response<T>` en `Resource<T>`.
- **`core/InternetConnectionHelper.kt`**: comprobación de conectividad antes de cada llamada.
- **`core/Utils.kt`** `@Singleton`: navegación (`goToMain/goToLogin/goToLock/goToAdmin`), diálogos, permisos (EasyPermissions), GPS, conversión Bitmap↔Base64, utilidades de impresión (`addSpaces`).
- **`core/SharedPreferencesManager.kt`** `@Inject`: sesión (`createLoginSession`, `getRememberMe`, `checkLogin`, `logoutUser`).
- **`core/Constantes.kt`**: claves de preferencias ofuscadas, nombres de BD, tamaños de paginación (`QUERY_PAGE_SIZE=20`), request codes, tags, intervalo GPS (`LOCATION_UPDATE_INTERVAL=5000`, `FASTEST=2000`), colores de gráficas.

### 1.4 DI (Hilt)

- `SupervisoresApp : Application` con `@HiltAndroidApp`.
- **`di/AppModule.kt`** (`@InstallIn(SingletonComponent)`): `baseUrl` (de `BuildConfig`), `OkHttpClient` (timeouts 100 s; logger BODY solo en DEBUG), `Retrofit` (Gson), `SupervisoresService`, `SupervisoresDatabase` (Room, `fallbackToDestructiveMigration`), `SharedPreferences` (`user_data.conf`), `SharedPreferencesManager`, y los DAOs (`ImeiDao`, `FotografiaDao`, `UsuarioDao`) + `Usuario` inicial leído con `usuarioDao.getUsuario()`.
- **`di/ServiceModule.kt`** (`@InstallIn(ServiceComponent)`): `FusedLocationProviderClient` `@ServiceScoped` para `LocationService`.

---

## 2. Flujo de Datos (Data Flow)

### 2.1 Punto de entrada y ciclo de arranque

`AndroidManifest.xml` declara `android:name=".SupervisoresApp"` y **`SplashActivity` como LAUNCHER** (tema `SplashTheme`).

```
SplashActivity.onCreate()
   └─ animaciones top/bottom (top_animation / bottom_animation)
SplashActivity.onResume()
   └─ handler.postDelayed(runnable, 2000)
        ├─ session.getRememberMe() == true
        │     └─ if (!session.checkLogin()) utils.goToMain()   // IS_USER_LOGIN en SharedPreferences
        │        (si no logueado, checkLogin() → goToLogin())
        └─ else → utils.goToLogin()
```

- `Utils.goToX()` lanza `Intent` con `FLAG_ACTIVITY_CLEAR_TOP | NEW_TASK | CLEAR_TASK` (cada destino limpia la pila salvo el login que se rebobina).
- **`LoginActivity`** (tema `LoginTheme`):
  1. **Validación de IMEI**:
     - `SDK_INT >= Q` → observa `viewModel.getSavedImei()` (Room `tbl_imei`); si existe llama `validarImei(imei)`; si **no** existe → `utils.goToAdmin()` (registro de IMEI por administrador).
     - `SDK_INT < Q` → `getImei()` usa `TelephonyManager.deviceId` (API deprecada) y pide `READ_PHONE_STATE`.
  2. Respuesta IMEI (`ImeiResponse.estado`): `-1` → mensaje y oculta login; `1` + `registrado=true` → muestra tarjeta de login; `1` + `registrado=false` → `utils.goToLock()`.
  3. **Login** (`POST`/`GET` `/SupervisoresAPI/login`): `UsuarioResponse.estado`: `-1` credenciales/usuario inactivo; `-2`/`-3` sin permisos de supervisor; `1` → `upsertUser(...)`.
  4. `upsertUser` → borra usuarios previos, inserta el nuevo (`Room`), borra fotografías y `insertUserSharedPreferences(rememberMe)` → **`goToMain()`**.
- **`LockedActivity`** (tema `BlockedTheme`): dispositivo no registrado; botón administración visible solo en `SDK>=Q` → `goToAdmin()`.
- **`AdminActivity`** (tema `BlockedTheme`): login admin (`/SupervisoresAPI/loginAdmin`, estado `-2` = no administrador) → captura de IMEI con **validación Luhn** (`ImeiValidation.isValidIMEI`, 15 dígitos) → guarda en Room (`ImeiDao`) → `goToLogin()`.
- **`MainActivity`** (single-activity, `AppTheme.NoActionBar`): hosting del `NavHostFragment` + `DrawerLayout` + `NavigationView`. En `onCreate` infla `R.navigation.mobile_navigation`, observa `viewModel.getUser()` (LiveData de Room) y **según el rol**:
  - `tipoEmpleado == 21L` → **Supervisor**: start destination `nav_home`; visibles `nav_home`, `nav_tienda_asignada`, `nav_visita_Programada`, `nav_preventa`.
  - `tipoEmpleado == 25L` → **Gerente**: start destination `nav_autorizacion_pendiente`; visibles sólo autorizaciones + settings; oculta home/tienda/visita/preventa.
  - otro rol → `nav_preventa`.
  - Registra `FirebaseCrashlytics.setUserId / setCustomKeys`.

### 2.2 Mapa de navegación (`res/navigation/mobile_navigation.xml`)

| id | Destino | Pantalla |
|---|---|---|
| `nav_home` | `HomeFragment` | Dashboard de metas + venta de cilindros (pie chart) |
| `nav_tienda_asignada` | `TiendaAsignadaFragment` | Tiendas asignadas (paginado) |
| `nav_preventa` | `PreventaFragment` | Cortes de ruta (aceptar/rechazar + impresión) |
| `nav_visita_Programada` | `VisitaProgramadaFragment` | Visitas programadas por fecha + bottom sheet |
| `visitaBottomSheet` (dialog) | `VisitaBottomSheetDialogFragment` | Acciones de la visita (checklist/metas/inventario) |
| `nav_autorizacion_pendiente` | `AutorizacionCorteFragment` | Autorizaciones de corte (rol gerente) |
| `nav_about` | `SettingsFragment` | Preferencias (`root_preferences.xml`) |

### 2.3 Flujo de datos genérico

```
Fragment/Activity (ViewBinding)
   │ observe LiveData                    ▲ postValue
   ▼                                     │
XxxViewModel : AndroidViewModel          │  MutableLiveData<Resource<T>>
   │ viewModelScope.launch               │
   ▼                                     │
XxxRepository (@Inject)                  │
   ├─ Room DAO (LiveData)  ──────────────┤  (usuario/fotografías)
   └─ SupervisoresService (Retrofit) ────┘
          │ suspend fun(): Response<T>
          ▼
   InternetConnectionHelper.hasInternetConnection()
          │
          ▼
   RetrofitHandleCall.handleCallResponse(response) → Resource<T>
```

Patrón repetido en **todos** los ViewModels: método `safeXxx()` que (1) emite `Loading`, (2) verifica internet, (3) llama al repositorio, (4) mapea a `Resource.Success/Error` (capturando `IOException` y `Throwable`). El repositorio **no** transforma; el mapeo HTTP→dominio es de `RetrofitHandleCall`.

### 2.4 Flujo crítico: Preventa y Corte (con GPS + impresión)

`PreventaFragment` orquesta tres servicios/piezas:

```
1) getCortesPendientes(usuario)            → muestra tarjeta del corte (punto de venta, total, fecha, estado autorización)
2) Aceptar/Rechazar corte:
     utils.checkGpsStatus() → Intent(LocationService, ACTION_START_OR_RESUME_SERVICE)
         LocationService (FusedLocationProviderClient, foreground 'location')
             → locationStatus LiveData<LocationResource<Location>>
     Al recibir lat/lng:
         STOP LocationService → AlertDialog confirmar
             ├─ Aceptar(tipo=1) → showDialogBag() pide IdentificadorBolsa + Placa → CorteRequest(tokenId, entregaEnc, tipo, lat, lng)
             └─ Rechazar(tipo=2) → CorteRequest directo
         viewModel.aceptarRechazarCorte(usuario, request)  → /SupervisoresAPI/AceptarRechazarCorte
3) Respuesta CorteResponse.estado (códigos -14..2, ver §4) :
     estado == 1 → showPrintDialog(datosImpresion) → PrinterDialogFragment (dispositivos emparejados)
        → Intent(PrintService, ACTION_START_OR_RESUME_SERVICE) con extras "printDevice" + "datosImpresion"
        → PrintService (foreground 'connectedDevice') imprime constancia Bixolon
        → PrintService.printStatus LiveData<Resource<Int>>
              Success(1) → refresca getCortesPendientes + diálogo "Corte aceptado"
```

### 2.5 Persistencia local (Room)

- BD `supervisores_db.db`, versión **3**, `exportSchema=false`, `fallbackToDestructiveMigration()`.
- Entidades: `Imei` (`tbl_imei`), `Usuario` (`tbl_usuario`), `FotografiaResponse` (`tbl_fotografia`).
- `UsuarioDao` (upsert/getUsuario LiveData/getUser/deleteAll/getCodigoUsuario), `ImeiDao` (upsert/getImei LiveData/deleteImei), `FotografiaDao` (upsert/getFotografias LiveData/delete*).
- Sesión simple en `SharedPreferences` (`user_data.conf`), claves ofuscadas `IS_USER_LOGIN`, `REMEMBER_ME`. **No hay token de autenticación**: la identidad se propaga por el parámetro `usuario` en cada request y el usuario vive en Room.

---

## 3. Desglose de Archivos Clave de Todo el Repositorio

### 3.1 `core/` (transversal)

| Archivo | Rol |
|---|---|
| `Bezier.kt`, `ControlTimedPoints.kt`, `TimedPoint.kt` | Matemática de curvas para la firma (`SignatureView`). |
| `BluetoothHelper.kt` | `isEnabled()` / `getStateBluetooth()` sobre `BluetoothAdapter`. |
| `Constantes.kt` | Constantes globales (preferencias, BD, request codes, GPS, impresión). |
| `Extensions.kt` | Extensiones Kotlin (p. ej. `hideKeyboard()`). |
| `FragmentViewBinding.kt` | Delegado `viewBinding(...)` para Activities/Fragments. |
| `ImeiValidation.kt` | `isValidIMEI(Long)`: valida 15 dígitos con checksum **Luhn** (usado en `AdminActivity`). |
| `InternetConnectionHelper.kt` | Conectividad (WIFI/CELLULAR/ETHERNET). |
| `LocationResource.kt` | `sealed class` con `Success/Error/Loading/Nothing`. |
| `Resource.kt` | `sealed class` de estado (`Success/Error/Loading`). |
| `RetrofitHandleCall.kt` | `handleCallResponse(Response<T>): Resource<T>`. |
| `SharedPreferencesManager.kt` | Sesión en `SharedPreferences`. |
| `Utils.kt` | Navegación, diálogos, permisos, GPS, Base64, espaciado de impresión, listas de acciones bottom-sheet. |
| `core/view/{SignatureView,utils,ViewTreeObserverCompat}.kt` | Vista de firma manuscrita y utilidades. |

### 3.2 `data/`

| Archivo | Rol |
|---|---|
| `remote/SupervisoresService.kt` | Interfaz Retrofit con **~30 endpoints** bajo `SupervisoresAPI/` (login/loginAdmin/ValidarImei/CrearToken/tiendas/cortes/visitas/puntos de venta/incidencias/inventario/metas/autorizaciones). |
| `local/SupervisoresDatabase.kt` | Room DB (v3) + singleton `invoke(context)`. |
| `local/{UsuarioDao,ImeiDao,FotografiaDao}.kt` | DAOs. |
| `models/*.kt` (**~70 archivos**) | POJOs Gson/Room: `Usuario`, `Imei(+Response)`, `UsuarioResponse`, `Tienda(+Response)`, `PuntoVenta(+Response)`, `VisitaProgramada(+Response)`, `VisitaRequest`, `VisitaInventario`, `CorteRequest/Response`, `CortesPendientes(+Response)`, `Incidencia(+Request/Response)`, `TipoIncidencia(+s Response)`, `FotografiaRequest/Response`, `IncidenciaFotografiaRequest`, `AutorizacionCorteRequest`, `AutorizacionPendiente`, `AutorizacionesPendienteResponse`, `MetaProyeccion`, `VentaCilindrosResponse`, `Cilindro`, `Inventario(+Request/Response)`, `DiferenciasResponse`, `DiferenciaProducto`, `TokenResponse`, `GenericResponse`, `DatosImpresion`, `PrintDevice`, `AccionBottom`, `Location`, `DetalleProducto`, `UsuarioSupervisor(+Response)`, `CerrarIncidenciaRequest`, entre otros. |

### 3.3 `services/`

| Archivo | Rol |
|---|---|
| `LocationService.kt` | `LifecycleService` en primer plano (`foregroundServiceType="location"`). Usa `FusedLocationProviderClient.lastLocation`; si es null solicita una única actualización (`PRIORITY_HIGH_ACCURACY`). Publica en `LocationService.locationStatus`. Canal de notificación `tracking_channel`. |
| `PrintService.kt` | `LifecycleService` en primer plano (`foregroundServiceType="connectedDevice"`). Inicializa `BXLConfigLoader`+`POSPrinter` (crea `jpos.xml` si falta), registra listeners de error/estado, imprime constancia (logo `ltropigas`/`lgasmetro`, montos, cilindros, firma) en hilo **IO**, y publica en `PrintService.printStatus`. `setProductName()` mapea modelos SPP/SRP a constantes Bixolon. |

### 3.4 `ui/` — Activities

| Archivo | Rol | Lógica destacada |
|---|---|---|
| `splash/SplashActivity.kt` | Launcher; anima y decide ruta por sesión. | `handler.postDelayed(2000)`. |
| `login/LoginActivity.kt` + `LoginViewModel` + `LoginRepository` | Login + validación IMEI. | `getSavedImei`, `getImei`, `upsertUser`. |
| `admin/AdminActivity.kt` + `AdminViewModel` + `AdminRepository` | Alta de IMEI por administrador. | `isValidIMEI`, `loginAdmin`, `saveImei`. |
| `lock/LockedActivity.kt` | Equipo no registrado / bloqueado. | Acceso a administración en `SDK>=Q`. |
| `main/MainActivity.kt` + `MainViewModel` + `MainRepository` | Single-activity, drawer, roles. | `setStartDestination` según `tipoEmpleado`; logout. |
| `checklist/CheckListActivity.kt` + VM + Repo | Checklist de visita, abre/cierra incidencia. | `obtenerTipoIncidenciasPorVisita`, `validarEstadoVisita`, `abrirIncidencia`. |
| `incidencia/IncidenciaActivity.kt` + VM + Repo | Registro de incidencia con fotografías. | `dispatchTakePictureIntent`, `crearIncidencia*`, grid de fotos. |
| `inventario/InventarioActivity.kt` + VM + Repo | Inventario de la visita. | `obtenerVisitaInventario`, `crearActualizarInventario`, `updateItem`. |
| `meta/MetasActivity.kt` + VM + Repo | Metas/venta por **punto de venta** (pantalla completa con pie chart). | `obtenerMetasPorPuntoVenta`, `obtenerVentaCilindrosPorPuntoVenta`. |
| `programar_visita/ProgramarVisitaActivity.kt` + VM + Repo | Programación de visita (punto de venta + fecha). | `crearVisitaProgramada(Gson().toJson(request))`, `DatePickerDialog`. |
| `signature/SignatureActivity.kt` + VM + Repo | Firma del supervisor e **cierre de incidencia**. | `SignatureView.OnSignedListener`, `cerrarIncidencia`. |

### 3.5 `ui/` — Fragments

| Archivo | Rol |
|---|---|
| `home/HomeFragment.kt` + VM + Repo | Dashboard: barra de metas (`round-corner-progress-bar`) + pie chart de venta de cilindros (MPAndroidChart). |
| `tienda/TiendaAsignadaFragment.kt` + VM + Repo | Lista paginada de tiendas asignadas (`QUERY_PAGE_SIZE=20`). |
| `preventa/PreventaFragment.kt` + VM + Repo | Cortes de ruta: token, aceptar/rechazar, GPS, impresión, diálogos de diferencias. **Núcleo funcional.** |
| `visita/VisitaProgramadaFragment.kt` + VM + Repo | Visitas por fecha (spinner de días + DatePicker) y bottom sheet de acciones. |
| `autorizacion_corte/AutorizacionCorteFragment.kt` + VM + Repo | Autorizaciones pendientes (rol gerente), motivo de rechazo, visualización de diferencias. |
| `settings/SettingsFragment.kt` | `PreferenceFragmentCompat` (`root_preferences.xml`). |

### 3.6 `ui/dialogs/` y `ui/adapters/`

- **Dialogs:** `LoadingDialog`, `PrintLoadingDialog`, `PrinterDialogFragment` (dispositivos emparejados; habilita Bluetooth; `enableBluetooth`), `PuntoVentaDialogFragment` (búsqueda de PDV), `UsuarioSupervisorDialogFragment` (selección de supervisor por planta), `InventarioDialogFragment` (contadores llenos/vacíos/propios), `VisitaBottomSheetDialogFragment` (acciones), `DiferenciasDialogFragment` y `RechazoDiferenciasDialogFragment` (+ repos/VM para solicitar autorización de corte).
- **Adapters (11):** `AccionesBottomAdapter`, `AutorizacionesPendientesAdapter`, `CheckListAdapter`, `DiferenciasAdapter`, `FotografiaAdapter`, `InventarioAdapter`, `PrinterAdapter`, `PuntoVentaAdapter`, `TiendaAsignadaAdapter`, `UsuarioSupervisorAdapter`, `VisitaProgramadaAdapter` (todos `RecyclerView.Adapter` con `DiffUtil` y callbacks `setOnItemClickListener`).

---

## 4. Lógica de Negocio y Métodos Críticos

### 4.1 API — `SupervisoresService` (`data/remote`)

Base URL: `BuildConfig.API_SUPERVISORES_BASE_URL` = `https://pruebasgenesys.tomzagroup.com/` (debug **y** release). HTTP/1.1, timeouts 100 s.

| Método | HTTP / Endpoint | Parámetros | Respuesta |
|---|---|---|---|
| `login` | GET `SupervisoresAPI/login` | `usuario`, `password` | `UsuarioResponse` |
| `loginAdmin` | GET `SupervisoresAPI/loginAdmin` | `usuario`, `password` | `UsuarioResponse` |
| `validarImei` | GET `SupervisoresAPI/ValidarImei` | `imei` | `ImeiResponse` |
| `crearToken` | GET `SupervisoresAPI/CrearToken` | `usuario` | `TokenResponse` |
| `obtenerTiendasAsignadasPorUsuario` | GET `.../ObtenerTiendasAsignadasPorUsuario` | `usuario`, `pageNumber=1` | `TiendaResponse` |
| `obtenerCortesPendientes` | GET `.../ObtenerCortesPendientes` | `usuario` | `CortesPendientesResponse` |
| `aceptarRechazarCorte` | POST `.../AceptarRechazarCorte` | body `CorteRequest` | `CorteResponse` |
| `obtenerVisitasProgramadas` | GET `.../ObtenerVisitasPorgramadasPorUsuario`¹ | `usuario`, `fecha` | `VisitaProgramadaResponse` |
| `buscarPuntoVentaPorUsuario` | GET `.../BuscarPuntoVentaPorUsuario` | `usuario`, `descripcion` | `PuntoVentaResponse` |
| `crearVisitaProgramada` | GET `.../CrearVisitaProgramada` | `visitaRequest` (JSON string) | `GenericResponse` |
| `obtenerTipoIncidenciasPorVisita` | GET `.../ObtenerTipoIncidenciasPorVisita` | `visitaEncabezado` | `TipoIncidenciasResponse` |
| `crearVisitaIncidencia` | POST `.../CrearActualizarIncidencia` | body `IncidenciaRequest` | `GenericResponse` |
| `obtenerIncidencia` | GET `.../ObtenerIncidencia` | `incidenciaId` | `IncidenciaResponse` |
| `crearIncidenciaFotografia` | POST `.../CrearIncidenciaFotografia` | body `FotografiaRequest` | `GenericResponse` |
| `eliminarIncidenciaFotografia` | DELETE `.../EliminarIncidenciaFotografia` | `incidenciaFotografiaId` | `GenericResponse` |
| `validarEstadoVisita` | GET `.../ValidarEstadoVisita` | `visitaId` | `GenericResponse` |
| `abrirIncidencia` | POST `.../AbrirIncidencia` | body `IncidenciaRequest` | `GenericResponse` |
| `cerrarIncidencia` | POST `.../CerrarIncidencia` | body `CerrarIncidenciaRequest` | `GenericResponse` |
| `obtenerFecha` | GET `.../ObtenerFecha` | — | `GenericResponse` |
| `obtenerMetasPorPuntoVenta` | GET `.../ObtenerMetasPorPuntoVenta` | `puntoVenta` | `MetaProyeccion` |
| `obtenerVentaCilindrosPorPuntoVenta` | GET `.../ObtenerVentaCilindrosPorPuntoVenta` | `puntoVenta` | `VentaCilindrosResponse` |
| `obtenerVisitaInventario` | GET `.../ObtenerVisitaInventario` | `visita`, `puntoVenta` | `InventarioResponse` |
| `crearActualizarInventario` | POST `.../CrearActualizarInventario` | body `InventarioRequest` | `GenericResponse` |
| `obtenerMetasPorUsuario` | GET `.../ObtenerMetasPorUsuario` | `usuario` | `MetaProyeccion` |
| `obtenerVentaCilindrosPorUsuario` | GET `.../ObtenerVentaCilindrosPorUsuario` | `usuario` | `VentaCilindrosResponse` |
| `obtenerSupervisores` | GET `.../ObtenerSupervisores` | `planta` | `UsuarioSupervisorResponse` |
| `obtenerAutorizacionesPendientes` | GET `.../ListarAutorizacionesPendientes` | `usuario` | `AutorizacionesPendienteResponse` |
| `cambiarEstadoAutorizacionCorte` | POST `.../CambiarEstadoAutorizacionCorte` | `usuario`, `autorizacionCorte`, `estado`, `motivo` | `GenericResponse` |
| `obtenerInventario` | GET `.../ObtenerInventario` | `visita`, `puntoVenta`, `noCorte`, `usuario` | `DiferenciasResponse` |
| `solicitarAutorizacionCorte` | POST `.../SolicitarAutorizacionCorte` | body `AutorizacionCorteRequest` | `GenericResponse` |

> ¹ El endpoint está escrito `ObtenerVisitasPorgramadasPorUsuario` (typo "Porgramadas" en el backend). **No corregir** sin coordinar cambios de servidor.

### 4.2 Códigos de estado de `AceptarRechazarCorte` (`CorteResponse.estado`)

Manejados en `PreventaFragment.subscribeToObservers()`:

| Estado | Significado / Acción UI |
|---|---|
| `1` | Éxito → `showPrintDialog(datosImpresion)` |
| `-1` | Mensaje genérico del backend (`mensaje`) |
| `-2` | Identificador de bolsa no existe |
| `-3` | Identificador de bolsa no asignada |
| `-4` | Identificador de bolsa no disponible |
| `-5` | Placa no encontrada |
| `-6` | Placa sin usuario asignado |
| `-7` | Sin visita |
| `-8` | Sin inventario del PDV |
| `-9` | Sin inventario del día |
| `-10` | Muestra `RechazoDiferenciasDialogFragment` (flujo 2) |
| `-11` | PDV sin ubicación |
| `-12` | Error de ubicación actual |
| `-13` | Muestra `RechazoDiferenciasDialogFragment` (flujo 1) + refresca |
| `-14` | Autorización pendiente |
| `2` | Corte rechazado |

### 4.3 Algoritmos y métodos críticos

- **`ImeiValidation.isValidIMEI(number: Long): Boolean`** — valida longitud 15 y checksum **Luhn** (dobla dígitos pares, suma dígitos). Se usa solo en `AdminActivity` al registrar un IMEI; el login delega la validación al backend (`ValidarImei`).
- **`MainActivity` role routing** — `isSupervisor = tipoEmpleado == 21L`, `isGerente = tipoEmpleado == 25L`; ajusta `graph.setStartDestination(...)` y visibilidad de ítems del drawer. También propaga `isSupervisor` a `VisitaProgramadaFragment` → bottom sheet.
- **`PreventaFragment.aceptarRechazarCorte(tipo)`** — exige GPS activo (`checkGpsStatus`), arranca `LocationService`, y con la ubicación recibida construye `CorteRequest(tokenId, entregaEnc, tipo, lat, lng)`.
- **`PrintService.printReceipt()`** — ejecuta en `lifecycleScope.launch(Dispatchers.IO)`; abre/claim `POSPrinter`, fija `CS_1252_LATIN1`, imprime logo según `empresa` (`1/4`→Tropigas, `2/5`→Gas Metro), encabezado "Constancia de Abastecimiento", corte, resumen de cilindros y firma. Publica `Success(1)`; `killService()` cierra la impresora con `try/catch(Exception)`.
- **`LocationService.locationTracking()`** — usa `lastLocation`; si no hay, solicita una única actualización de alta precisión; remueve el callback tras recibirla y hace `postValue`. Servicio de primer plano con tipo `location`.
- **`RetrofitHandleCall.handleCallResponse()`** — única traducción HTTP→dominio; si `!isSuccessful` produce `Resource.Error(response.message())`.
- **Conversión de imágenes** (`Utils.convertByteToBase64`, `convertBitmapToBase64`, `convertBase64ToBitmap`): corrección de orientación EXIF y compresión JPEG (calidad 50 para fotos, 80 para firma) antes de enviar a `CrearIncidenciaFotografia`.
- **Serialización de visita** (`ProgramarVisitaRepository`): `supervisoresService.crearVisitaProgramada(Gson().toJson(visitaRequest))` — envía JSON como parámetro de query.

---

## 5. Guía de Ejecución y Testing

### 5.1 Requisitos

- **JDK 21** (obligatorio: `sourceCompatibility/targetCompatibility = VERSION_21` y flags `--add-exports` para kapt).
- Android SDK con **API 37** instalado (`compileSdk/targetSdk 37`); `local.properties` con `sdk.dir`.
- `google-services.json` presente en `app/` (ya incluido).
- Conexión al backend QA `https://pruebasgenesys.tomzagroup.com/`.

### 5.2 Compilar / ejecutar

```bash
# Desde la raíz del proyecto (donde está gradlew / gradlew.bat)
./gradlew clean
./gradlew assembleDebug          # APK debug
./gradlew assembleRelease        # APK release (requiere firma configurada)
./gradlew installDebug           # instala en dispositivo/emulador conectado
./gradlew test                   # pruebas unitarias (src/test)
./gradlew connectedAndroidTest   # pruebas instrumentadas (src/androidTest, requiere device)
./gradlew lint
./gradlew :app:dependencies      # resolución de dependencias
```

En Windows (PowerShell/CMD): `gradlew.bat assembleDebug`.

> ⚠️ `app/build.gradle` **no declara bloque `signingConfigs`**. Para `assembleRelease` el proyecto usará una firma por defecto/debug o fallará según el entorno; los keystores existen en `apk/` (`TropiSupervisoresKeyStore.jks/.p12`) pero no están cableados en Gradle. Verificar antes de distribuir.

### 5.3 Estrategia de pruebas propuesta

No hay pruebas reales: `ExampleUnitTest`/`ExampleInstrumentedTest` son plantillas. Estrategia mínima sugerida (priorizada):

1. **Unitarias (JVM, `src/test`)**
   - `ImeiValidation.isValidIMEI`: casos válido/inválido/longitud incorrecta (determinista, sin Android).
   - `Utils.sameDates`, `Utils.addSpaces`: formato de fecha y padding de impresión (Luhn/espaciado son los puntos más frágiles).
   - Mapeo de `CorteResponse.estado` → mensaje/acción (extraer a un mapper testeable).
   - `RetrofitHandleCall.handleCallResponse`: éxito, body nulo, error HTTP.
2. **Instrumentadas / Robolectric**
   - `SupervisoresDatabase` (Room in-memory): upsert/consulta de `Usuario`, `Imei`, `FotografiaResponse`.
   - `SharedPreferencesManager.checkLogin/logoutUser` con `SharedPreferences` de prueba.
3. **UI (Espresso)**
   - `LoginActivity`: flujo IMEI no registrado → `LockedActivity`; credenciales inválidas → diálogo.
   - `MainActivity`: rol supervisor vs gerente → start destination y visibilidad del drawer.
4. **Manual (hardware real, imprescindible para impresión/GPS)**
   - `PreventaFragment`: aceptar corte con GPS, imprimir constancia en Bixolon, verificar refresco de la pantalla tras `Success(1)` (regresión documentada en `.artifacts/`).
   - `LocationService`/`PrintService` en Android 14+: verificar tipos de FGS y permisos.
   - `IncidenciaActivity`: captura, rotación EXIF y subida de fotografías.

### 5.4 Smoke test funcional (orden sugerido)

1. Arranque en equipo **sin IMEI** → `AdminActivity` → login admin → registrar IMEI (Luhn válido).
2. `SplashActivity` con *Remember me* → `MainActivity`.
3. Login supervisor (rol 21) → `nav_home` con metas y pie chart.
4. `PreventaFragment`: listar corte pendiente → aceptar con GPS → imprimir → verificar refresco.
5. `VisitaProgramadaFragment` → bottom sheet → `CheckListActivity` → incidencia + fotos → `SignatureActivity` (cierre).
6. Login gerente (rol 25) → `AutorizacionCorteFragment` → autorizar/rechazar con motivo.

---

## 6. Estado, Deuda Técnica y Pendientes

### 6.1 Trabajo reciente (`.artifacts/`)

Documentado y marcado como completado:

- `PrintService`: creación de `jpos.xml` si falta, impresión movida a **hilo IO**, corrección de **race-condition** `Success(1)` vs reset `Success(-1)`, y cierre de impresora con `catch(Exception)`.
- `LocationService`: cumplimiento Foreground Service **Android 14+**.
- `PreventaFragment`: uso de `ContextCompat.startForegroundService()` y refresco tras impresión exitosa.
- `task.artifact.md` lista las 9 tareas de esas correcciones como `[x]`.

### 6.2 Riesgos y hallazgos (revisar antes de producción)

- 🔴 **Release apunta a QA**: `debug` y `release` usan `https://pruebasgenesys.tomzagroup.com/`. Falta el `buildConfigField` de producción en `release`.
- 🔴 **Secretos/artefactos sensibles en el repo**: `apk/` contiene `TropiSupervisoresKeyStore.jks`, `.p12`, `private_key.pepk` y `Datos Tropi Supervisores.docx`; además `google-services.json` está versionado. Rotar credenciales y sacarlos del control de versiones si el repo es compartido.
- 🟠 **Sin token de autenticación**: todas las llamadas se autorizan con el parámetro `usuario`; existe `TokenResponse`/`CrearToken` solo como token operativo de corte, no como sesión HTTP.
- 🟠 **IMEI en Android moderno**: `TelephonyManager.deviceId` está deprecado y bloqueado desde Android 10; la app lo evita en `SDK>=Q` usando el IMEI guardado en Room, con fallback a `AdminActivity`. Documentar y eventualmente migrar a Android ID/`getImei()` con `READ_PRIVILEGED_PHONE_STATE` (no aplicable a apps de usuario).
- 🟠 **`fallbackToDestructiveMigration()`** en Room: cualquier cambio de esquema **borra** los datos locales (usuario/fotos) sin migración.
- 🟠 **`allowBackup="false"`** (correcto) y `largeHeap="true"` (a vigilar por consumo de memoria en fotos).
- 🟡 **Dependencias antiguas**: `lifecycle-extensions 2.1.0`, `coroutines 1.4.1`, `navigation 2.5.3`, `play-services-location 18.0.0`, `Retrofit 2.9.0`; `enableJetifier=true`. Candidatos a actualización.
- 🟡 **Mix de toolchain**: Kotlin `1.9.24` sobre JDK 21 + kapt con `--add-exports`; migrar a **KSP** eliminaría esa fricción y aceleraría la compilación.
- 🟡 **`minSdk 21`** con Compose no aplica aquí (es Views), pero limita APIs y obliga a ramas `Build.VERSION` (login IMEI, permisos Bluetooth, FGS).
- 🟡 **Sin cobertura de pruebas** real.
- 🟡 **`rootProject.buildDir` deprecado** en `build.gradle` raíz (`task clean(type: Delete)`) — reemplazar por `layout.buildDirectory` en Gradle 8+.

### 6.3 Módulos/assumptions pendientes de revisión

- `MetasActivity` (metas por PDV) vs `HomeFragment` (metas por usuario): dos vistas de metas con propósitos distintos; confirmar cuál se usa en producción y desde dónde se lanza `MetasActivity` (no aparece como destino del `NavHost` en `mobile_navigation.xml` — se abre por `Intent` desde el bottom sheet de visita).
- `SettingsFragment` (`root_preferences.xml`): verificar qué preferencias son realmente funcionales.
- Roles adicionales distintos de 21/25 caen por defecto en `nav_preventa`; confirmar si es el comportamiento deseado.
- `assets/` incluye varios Lottie y fuentes; confirmar cuáles siguen en uso.

---

## Anexo A — Inventario de paquetes y archivos (referencia rápida)

```
com.tomzagroup.tropisupervisores
├── SupervisoresApp.kt                     (@HiltAndroidApp)
├── core/            (~18 archivos)        constantes, Resource, Utils, permisos, IMEI, Bluetooth, firma
├── data/
│   ├── local/       4 DAOs/DB             Room (tbl_usuario, tbl_imei, tbl_fotografia)
│   ├── models/      ~70 POJOs             request/response/modelos Gson/Room
│   └── remote/      1 service             SupervisoresService (Retrofit, ~30 endpoints)
├── di/              2 módulos             AppModule (Singleton), ServiceModule (Service)
├── services/        2 servicios           LocationService, PrintService (foreground)
└── ui/
    ├── activities/  11 paquetes           splash, login, admin, lock, main, checklist,
    │                                       incidencia, inventario, meta, programar_visita, signature
    ├── adapters/    11 adapters           RecyclerView + DiffUtil
    ├── dialogs/     7 paquetes            loading, print, printers, punto_venta, supervisor,
    │                                       inventario, diferencias, vista_bottom
    └── fragments/   6 paquetes            home, tienda, preventa, visita, autorizacion_corte, settings
```

## Anexo B — Servicios en primer plano (Android 14+)

| Servicio | `foregroundServiceType` | Permiso manifest | Acción |
|---|---|---|---|
| `LocationService` | `location` | `FOREGROUND_SERVICE_LOCATION` (+ `ACCESS_FINE/COARSE_LOCATION`) | `ACTION_START_OR_RESUME_SERVICE` / `ACTION_STOP_SERVICE` |
| `PrintService` | `connectedDevice` | `FOREGROUND_SERVICE_CONNECTED_DEVICE` (+ `BLUETOOTH_*`) | `ACTION_START_OR_RESUME_SERVICE` / `ACTION_STOP_SERVICE` |

Canal de notificación compartido: `NOTIFICATION_CHANNEL_ID = "tracking_channel"` / `NOTIFICATION_CHANNEL_NAME = "Printing"`.

---

*Fin del documento. Toda la información proviene del código fuente real; los puntos marcados como "assumptions/pendientes" deben confirmarse con el equipo de desarrollo.*
