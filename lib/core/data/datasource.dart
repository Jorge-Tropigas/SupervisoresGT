// Dart imports:
import 'dart:developer' as dev;

// Package imports:
import 'package:tomza_kit/tomza_kit.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/model/request/accept_reject_cut_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/change_auth_status_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/close_incident_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/create_photo_incident_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/create_update_incident_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/create_update_inventory_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/delete_photo_incident_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/get_cylinder_sale_point_sale_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/get_cylinder_sales_user_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/get_incident_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/get_incident_types_visit_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/get_inventory_differences_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/get_inventory_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/get_supervisors_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/get_target_sale_point_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/incident_open_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/list_pending_auth_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/login_admin_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/login_user_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/request_auth_cut_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/retrieve_goals_user_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/retrieve_pending_cuts_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/retrieve_scheduled_visits_user_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/retrieve_stores_assigned_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/search_sale_point_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/token_generate_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/valid_imei_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/valid_visit_status_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/visit_request.dart';
import 'package:app_supervisores_gt/core/data/model/response/accept_reject_cut_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/close_incident_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/create_photo_incident_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/create_update_incident_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/create_update_inventory_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/get_cylinder_sale_point_sale_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/get_cylinder_sales_user_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/get_date_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/get_incident_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/get_incident_types_visit_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/get_inventory_differences_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/get_inventory_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/get_supervisors_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/get_target_sale_point_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/incident_open_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/list_pending_auth_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/login_admin_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/login_user_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/retrieve_goals_user_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/retrieve_pending_cuts_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/retrieve_scheduled_visits_user_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/retrieve_stores_assigned_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/search_sale_point_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/token_generate_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/valid_imei_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/valid_visit_status_response.dart';
import 'package:app_supervisores_gt/core/data/model/response/visit_response.dart';
import 'package:app_supervisores_gt/core/service/env_service.dart';

abstract class Datasource {
  Future<LoginAdminResponse> loginAdmin(LoginAdminRequest request);
  Future<ValidImeiResponse> validImei(ValidImeiRequest request);
  Future<LoginUserResponse> login(LoginUserRequest request);
  Future<RetrieveGoalsByUserResponse> retrieveGoalsByUser(
    RetrieveGoalsByUserRequest request,
  );
  Future<GetCylinderSalesUserResponse> getCylinderSalesUser(
    GetCylinderSalesUserRequest request,
  );
  Future<RetrieveStoresAssignedResponse> retrieveStoresAssignes(
    RetrieveStoresAssignedRequest request,
  );
  Future<RetrieveScheduledVisitsUserResponse> retrieveScheduledVisits(
    RetrieveScheduledVisitsUserRequest request,
  );
  Future<RetrievePendingCutsResponse> retrievePendingCuts(
    RetrievePendingCutsRequest request,
  );
  Future<AcceptRejectCutResponse> acceptRejectCut(
    AcceptRejectCutRequest request,
  );
  Future<TokenGenerateResponse> tokenGenerate(TokenGenerateRequest request);
  Future<VisitResponse> createVisit(VisitRequest request);
  Future<GetIncidentTypesVisitResponse> incidentTypesByVisit(
    GetIncidentTypesVisitRequest request,
  );
  Future<ValidVisitStatusResponse> validVisitStatus(
    ValidVisitStatusRequest request,
  );
  Future<IncidentOpenResponse> incidentOpen(IncidentOpenRequest request);
  Future<GetIncidentResponse> getIncident(GetIncidentRequest request);
  Future<CreateUpdateIncidentResponse> createUpdateIncident(
    CreateUpdateIncidentRequest request,
  );
  Future<CloseIncidentResponse> closeIncident(CloseIncidentRequest request);
  Future<GetTargetSalePointResponse> getTargetSalePoint(
    GetTargetSalePointRequest request,
  );
  Future<GetCylinderSalePointSaleResponse> getCylinderSalePointSale(
    GetCylinderSalePointSaleRequest request,
  );
  Future<GetInventoryResponse> getInventory(GetInventoryRequest request);
  Future<CreateUpdateInventoryResponse> createUpdateInventory(
    CreateUpdateInventoryRequest request,
  );
  Future<ListPendingAuthResponse> listPendingAuth(
    ListPendingAuthRequest request,
  );
  Future<GetDateResponse> getDate();
  Future<SearchSalePointResponse> searchSalePoint(
    SearchSalePointRequest request,
  );
  Future<CreatePhotoIncidentResponse> createPhotoIncident(
    CreatePhotoIncidentRequest request,
  );
  Future<CreatePhotoIncidentResponse> deletePhotoIncident(
    DeletePhotoIncidentRequest request,
  );
  Future<GetSupervisorsResponse> getSupervisors(GetSupervisorsRequest request);
  Future<CreatePhotoIncidentResponse> changeAuthStatus(
    ChangeAuthStatusRequest request,
  );
  Future<GetInventoryDifferencesResponse> getInventoryDifferences(
    GetInventoryDifferencesRequest request,
  );
  Future<CreatePhotoIncidentResponse> requestAuthCut(
    RequestAuthCutRequest request,
  );
}

class DatasourceImpl implements Datasource {
  void _logRequest({
    required String method,
    required String endpoint,
    Json? query,
    dynamic body,
  }) {
    final cleanEndpoint = endpoint.startsWith('/')
        ? endpoint.substring(1)
        : endpoint;
    final normalizedEndpoint = endpoint.startsWith('/')
        ? endpoint
        : '/$endpoint';
    final base = EnvService.baseUrlNormalized;

    Uri fullUri = Uri.parse('$base$cleanEndpoint');
    if (query != null && query.isNotEmpty) {
      fullUri = fullUri.replace(
        queryParameters: query.map((k, v) => MapEntry(k, v?.toString() ?? '')),
      );
    }

    dev.log('------------------ SOLICITUD ------------------');
    dev.log('Solicitud    : $method');
    dev.log('URL completa : $fullUri');
    dev.log('Endpoint     : $normalizedEndpoint');
    if (query != null && query.isNotEmpty) {
      dev.log('Valores      : [Query Parameters]');
      query.forEach((key, value) {
        dev.log('  • $key: $value');
      });
    } else if (body != null) {
      dev.log('Valores      : [Cuerpo / Body]');
      if (body is Map) {
        body.forEach((key, value) {
          dev.log('  • $key: $value');
        });
      } else {
        dev.log('  • $body');
      }
    } else {
      dev.log('Valores      : Sin parámetros ni cuerpo');
    }
    dev.log('-----------------------------------------------');
  }

  @override
  Future<LoginAdminResponse> loginAdmin(LoginAdminRequest request) async {
    final queryParams = request.toJson();
    _logRequest(method: 'GET', endpoint: '/loginAdmin', query: queryParams);

    try {
      final json = await ApiClient.get('/loginAdmin', query: queryParams);
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /loginAdmin');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return LoginAdminResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /loginAdmin');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<ValidImeiResponse> validImei(ValidImeiRequest request) async {
    final queryParams = request.toJson();
    _logRequest(method: 'GET', endpoint: '/ValidarImei', query: queryParams);

    try {
      final json = await ApiClient.get('/ValidarImei', query: queryParams);
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /ValidarImei');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return ValidImeiResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /ValidarImei');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<LoginUserResponse> login(LoginUserRequest request) async {
    final queryParams = request.toJson();
    _logRequest(method: 'GET', endpoint: '/login', query: queryParams);

    try {
      final json = await ApiClient.get('/login', query: queryParams);
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /login');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return LoginUserResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /login');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<RetrieveGoalsByUserResponse> retrieveGoalsByUser(
    RetrieveGoalsByUserRequest request,
  ) async {
    final queryParams = request.toJson();
    _logRequest(
      method: 'GET',
      endpoint: '/ObtenerMetasPorUsuario',
      query: queryParams,
    );

    try {
      final json = await ApiClient.get(
        '/ObtenerMetasPorUsuario',
        query: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /ObtenerMetasPorUsuario');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return RetrieveGoalsByUserResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /ObtenerMetasPorUsuario');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<GetCylinderSalesUserResponse> getCylinderSalesUser(
    GetCylinderSalesUserRequest request,
  ) async {
    final queryParams = request.toJson();
    _logRequest(
      method: 'GET',
      endpoint: '/ObtenerVentaCilindrosPorUsuario',
      query: queryParams,
    );

    try {
      final json = await ApiClient.get(
        '/ObtenerVentaCilindrosPorUsuario',
        query: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /ObtenerVentaCilindrosPorUsuario');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return GetCylinderSalesUserResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /ObtenerVentaCilindrosPorUsuario');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<RetrieveStoresAssignedResponse> retrieveStoresAssignes(
    RetrieveStoresAssignedRequest request,
  ) async {
    final queryParams = request.toJson();
    _logRequest(
      method: 'GET',
      endpoint: '/ObtenerTiendasAsignadasPorUsuario',
      query: queryParams,
    );

    try {
      final json = await ApiClient.get(
        '/ObtenerTiendasAsignadasPorUsuario',
        query: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /ObtenerTiendasAsignadasPorUsuario');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return RetrieveStoresAssignedResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /ObtenerTiendasAsignadasPorUsuario');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<RetrieveScheduledVisitsUserResponse> retrieveScheduledVisits(
    RetrieveScheduledVisitsUserRequest request,
  ) async {
    final queryParams = request.toJson();
    _logRequest(
      method: 'GET',
      endpoint: '/ObtenerVisitasPorgramadasPorUsuario',
      query: queryParams,
    );

    try {
      final json = await ApiClient.get(
        '/ObtenerVisitasPorgramadasPorUsuario',
        query: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /ObtenerVisitasPorgramadasPorUsuario');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return RetrieveScheduledVisitsUserResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /ObtenerVisitasPorgramadasPorUsuario');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<RetrievePendingCutsResponse> retrievePendingCuts(
    RetrievePendingCutsRequest request,
  ) async {
    final queryParams = request.toJson();
    _logRequest(
      method: 'GET',
      endpoint: '/ObtenerCortesPendientes',
      query: queryParams,
    );

    try {
      final json = await ApiClient.get(
        '/ObtenerCortesPendientes',
        query: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /ObtenerCortesPendientes');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return RetrievePendingCutsResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /ObtenerCortesPendientes');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<AcceptRejectCutResponse> acceptRejectCut(
    AcceptRejectCutRequest request,
  ) async {
    final queryParams = request.toJson();
    _logRequest(
      method: 'POST',
      endpoint: '/AceptarRechazarCorte',
      query: queryParams,
    );

    try {
      final json = await ApiClient.post(
        '/AceptarRechazarCorte',
        body: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /AceptarRechazarCorte');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return AcceptRejectCutResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /AceptarRechazarCorte');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<TokenGenerateResponse> tokenGenerate(
    TokenGenerateRequest request,
  ) async {
    final queryParams = request.toJson();
    _logRequest(method: 'GET', endpoint: '/CrearToken', query: queryParams);

    try {
      final json = await ApiClient.get('/CrearToken', query: queryParams);
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /CrearToken');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return TokenGenerateResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /CrearToken');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<VisitResponse> createVisit(VisitRequest request) async {
    final queryParams = request.toJson();
    _logRequest(
      method: 'GET',
      endpoint: '/CrearVisitaProgramada',
      query: queryParams,
    );

    try {
      final json = await ApiClient.get(
        '/CrearVisitaProgramada',
        query: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /CrearVisitaProgramada');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return VisitResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /CrearVisitaProgramada');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<GetIncidentTypesVisitResponse> incidentTypesByVisit(
    GetIncidentTypesVisitRequest request,
  ) async {
    final queryParams = request.toJson();
    _logRequest(
      method: 'GET',
      endpoint: '/ObtenerTipoIncidenciasPorVisita',
      query: queryParams,
    );

    try {
      final json = await ApiClient.get(
        '/ObtenerTipoIncidenciasPorVisita',
        query: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /ObtenerTipoIncidenciasPorVisita');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return GetIncidentTypesVisitResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /ObtenerTipoIncidenciasPorVisita');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<ValidVisitStatusResponse> validVisitStatus(
    ValidVisitStatusRequest request,
  ) async {
    final queryParams = request.toJson();
    _logRequest(
      method: 'GET',
      endpoint: '/ValidarEstadoVisita',
      query: queryParams,
    );

    try {
      final json = await ApiClient.get(
        '/ValidarEstadoVisita',
        query: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /ValidarEstadoVisita');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return ValidVisitStatusResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /ValidarEstadoVisita');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<IncidentOpenResponse> incidentOpen(IncidentOpenRequest request) async {
    final queryParams = request.toJson();
    _logRequest(
      method: 'POST',
      endpoint: '/AbrirIncidencia',
      body: queryParams,
    );

    try {
      final json = await ApiClient.post('/AbrirIncidencia', body: queryParams);
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /AbrirIncidencia');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return IncidentOpenResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /AbrirIncidencia');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<GetIncidentResponse> getIncident(GetIncidentRequest request) async {
    final queryParams = request.toJson();
    _logRequest(
      method: 'GET',
      endpoint: '/ObtenerIncidencia',
      query: queryParams,
    );

    try {
      final json = await ApiClient.get(
        '/ObtenerIncidencia',
        query: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /ObtenerIncidencia');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return GetIncidentResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /ObtenerIncidencia');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<CreateUpdateIncidentResponse> createUpdateIncident(
    CreateUpdateIncidentRequest request,
  ) async {
    final queryParams = request.toJson();
    _logRequest(
      method: 'POST',
      endpoint: '/CrearActualizarIncidencia',
      body: queryParams,
    );

    try {
      final json = await ApiClient.post(
        '/CrearActualizarIncidencia',
        body: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /CrearActualizarIncidencia');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return CreateUpdateIncidentResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /CrearActualizarIncidencia');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<CloseIncidentResponse> closeIncident(
    CloseIncidentRequest request,
  ) async {
    final queryParams = request.toJson();
    _logRequest(
      method: 'POST',
      endpoint: '/CerrarIncidencia',
      body: queryParams,
    );

    try {
      final json = await ApiClient.post('/CerrarIncidencia', body: queryParams);
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /CerrarIncidencia');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return CloseIncidentResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /CerrarIncidencia');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<GetTargetSalePointResponse> getTargetSalePoint(
    GetTargetSalePointRequest request,
  ) async {
    final queryParams = request.toJson();
    _logRequest(
      method: 'POST',
      endpoint: '/ObtenerMetasPorPuntoVenta',
      body: queryParams,
    );

    try {
      final json = await ApiClient.get(
        '/ObtenerMetasPorPuntoVenta',
        query: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /ObtenerMetasPorPuntoVenta');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return GetTargetSalePointResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /ObtenerMetasPorPuntoVenta');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<GetCylinderSalePointSaleResponse> getCylinderSalePointSale(
    GetCylinderSalePointSaleRequest request,
  ) async {
    final queryParams = request.toJson();
    _logRequest(
      method: 'GET',
      endpoint: '/ObtenerVentaCilindrosPorPuntoVenta',
      body: queryParams,
    );

    try {
      final json = await ApiClient.get(
        '/ObtenerVentaCilindrosPorPuntoVenta',
        query: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /ObtenerVentaCilindrosPorPuntoVenta');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return GetCylinderSalePointSaleResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /ObtenerVentaCilindrosPorPuntoVenta');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<GetInventoryResponse> getInventory(GetInventoryRequest request) async {
    final queryParams = request.toJson();
    _logRequest(
      method: 'POST',
      endpoint: '/ObtenerVisitaInventario',
      body: queryParams,
    );

    try {
      final json = await ApiClient.get(
        '/ObtenerVisitaInventario',
        query: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /ObtenerVisitaInventario');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return GetInventoryResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /ObtenerVisitaInventario');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<CreateUpdateInventoryResponse> createUpdateInventory(
    CreateUpdateInventoryRequest request,
  ) async {
    final queryParams = request.toJson();
    _logRequest(
      method: 'POST',
      endpoint: '/CrearActualizarInventario',
      body: queryParams,
    );

    try {
      final json = await ApiClient.post(
        '/CrearActualizarInventario',
        body: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /CrearActualizarInventario');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return CreateUpdateInventoryResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /CrearActualizarInventario');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<ListPendingAuthResponse> listPendingAuth(
    ListPendingAuthRequest request,
  ) async {
    final queryParams = request.toJson();
    _logRequest(
      method: 'GET',
      endpoint: '/ListarAutorizacionesPendientes',
      query: queryParams,
    );

    try {
      final json = await ApiClient.get(
        '/ListarAutorizacionesPendientes',
        query: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /ListarAutorizacionesPendientes');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return ListPendingAuthResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /ListarAutorizacionesPendientes');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<GetDateResponse> getDate() async {
    _logRequest(method: 'GET', endpoint: '/ObtenerFecha');

    try {
      final json = await ApiClient.get('/ObtenerFecha');
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /ObtenerFecha');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return GetDateResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /ObtenerFecha');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<SearchSalePointResponse> searchSalePoint(
    SearchSalePointRequest request,
  ) async {
    final queryParams = {
      'usuario': request.user,
      'descripcion': request.description,
    };
    _logRequest(
      method: 'GET',
      endpoint: '/BuscarPuntoVentaPorUsuario',
      query: queryParams,
    );

    try {
      final json = await ApiClient.get(
        '/BuscarPuntoVentaPorUsuario',
        query: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /BuscarPuntoVentaPorUsuario');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return SearchSalePointResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /BuscarPuntoVentaPorUsuario');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<CreatePhotoIncidentResponse> createPhotoIncident(
    CreatePhotoIncidentRequest request,
  ) async {
    _logRequest(
      method: 'POST',
      endpoint: '/CrearIncidenciaFotografia',
      body: request.toJson(),
    );

    try {
      final json = await ApiClient.post(
        '/CrearIncidenciaFotografia',
        body: request.toJson(),
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /CrearIncidenciaFotografia');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return CreatePhotoIncidentResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /CrearIncidenciaFotografia');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<CreatePhotoIncidentResponse> deletePhotoIncident(
    DeletePhotoIncidentRequest request,
  ) async {
    final queryParams = {
      'incidenciaFotografiaId': request.incidentPhotoId.toString(),
    };
    _logRequest(
      method: 'DELETE',
      endpoint: '/EliminarIncidenciaFotografia',
      query: queryParams,
    );

    try {
      final json = await ApiClient.deleteJson(
        '/EliminarIncidenciaFotografia',
        query: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /EliminarIncidenciaFotografia');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return CreatePhotoIncidentResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /EliminarIncidenciaFotografia');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<GetSupervisorsResponse> getSupervisors(
    GetSupervisorsRequest request,
  ) async {
    final queryParams = {'planta': request.plant.toString()};
    _logRequest(
      method: 'GET',
      endpoint: '/ObtenerSupervisores',
      query: queryParams,
    );

    try {
      final json = await ApiClient.get(
        '/ObtenerSupervisores',
        query: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /ObtenerSupervisores');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return GetSupervisorsResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /ObtenerSupervisores');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<CreatePhotoIncidentResponse> changeAuthStatus(
    ChangeAuthStatusRequest request,
  ) async {
    final queryParams = {
      'usuario': request.user,
      'autorizacionCorte': request.authCutId.toString(),
      'estado': request.status.toString(),
      'motivo': request.reason,
    };
    _logRequest(
      method: 'POST',
      endpoint: '/CambiarEstadoAutorizacionCorte',
      query: queryParams,
    );

    try {
      final json = await ApiClient.post(
        '/CambiarEstadoAutorizacionCorte',
        query: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /CambiarEstadoAutorizacionCorte');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return CreatePhotoIncidentResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /CambiarEstadoAutorizacionCorte');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<GetInventoryDifferencesResponse> getInventoryDifferences(
    GetInventoryDifferencesRequest request,
  ) async {
    final queryParams = {
      'visita': request.visit.toString(),
      'puntoVenta': request.salePoint,
      'noCorte': request.cutNumber.toString(),
      'usuario': request.user,
    };
    _logRequest(
      method: 'GET',
      endpoint: '/ObtenerInventario',
      query: queryParams,
    );

    try {
      final json = await ApiClient.get(
        '/ObtenerInventario',
        query: queryParams,
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /ObtenerInventario');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return GetInventoryDifferencesResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /ObtenerInventario');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }

  @override
  Future<CreatePhotoIncidentResponse> requestAuthCut(
    RequestAuthCutRequest request,
  ) async {
    _logRequest(
      method: 'POST',
      endpoint: '/SolicitarAutorizacionCorte',
      body: request.toJson(),
    );

    try {
      final json = await ApiClient.post(
        '/SolicitarAutorizacionCorte',
        body: request.toJson(),
      );
      dev.log('------------------ RESPUESTA ------------------');
      dev.log('Endpoint  : /SolicitarAutorizacionCorte');
      dev.log('Respuesta : $json');
      dev.log('-----------------------------------------------');
      return CreatePhotoIncidentResponse.fromJson(json);
    } catch (e) {
      dev.log('------------------ ERROR ------------------');
      dev.log('Endpoint : /SolicitarAutorizacionCorte');
      dev.log('Error    : $e');
      dev.log('-------------------------------------------');
      rethrow;
    }
  }
}
