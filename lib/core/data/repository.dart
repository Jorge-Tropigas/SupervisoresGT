// Package imports:
import 'package:tomza_kit/core/network/network_exceptions.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/datasource.dart';
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

abstract class Repository {
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

class RepositoryImpl implements Repository {
  const RepositoryImpl({required this._datasource});

  final Datasource _datasource;

  @override
  Future<LoginAdminResponse> loginAdmin(LoginAdminRequest request) async {
    try {
      final result = await _datasource.loginAdmin(request);

      if (result.status != 1) {
        throw Exception('Error al iniciar sesión');
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<ValidImeiResponse> validImei(ValidImeiRequest request) async {
    try {
      final result = await _datasource.validImei(request);

      if (result.isRegister != true) {
        throw Exception(result.message);
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<LoginUserResponse> login(LoginUserRequest request) async {
    try {
      final result = await _datasource.login(request);

      if (result.status != 1) {
        throw Exception('Error al iniciar sesión');
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<RetrieveGoalsByUserResponse> retrieveGoalsByUser(
    RetrieveGoalsByUserRequest request,
  ) async {
    try {
      final result = await _datasource.retrieveGoalsByUser(request);

      if (result.status != 1) {
        throw Exception(result.message ?? 'Error al obtener las ventas');
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<GetCylinderSalesUserResponse> getCylinderSalesUser(
    GetCylinderSalesUserRequest request,
  ) async {
    try {
      final result = await _datasource.getCylinderSalesUser(request);

      if (result.status != 1) {
        throw Exception(
          result.message ?? 'Error al obtener la venta de los cilindros',
        );
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<RetrieveStoresAssignedResponse> retrieveStoresAssignes(
    RetrieveStoresAssignedRequest request,
  ) async {
    try {
      final result = await _datasource.retrieveStoresAssignes(request);

      return result;
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<RetrieveScheduledVisitsUserResponse> retrieveScheduledVisits(
    RetrieveScheduledVisitsUserRequest request,
  ) async {
    try {
      final result = await _datasource.retrieveScheduledVisits(request);

      return result;
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<RetrievePendingCutsResponse> retrievePendingCuts(
    RetrievePendingCutsRequest request,
  ) async {
    try {
      final result = await _datasource.retrievePendingCuts(request);

      return result;
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<AcceptRejectCutResponse> acceptRejectCut(
    AcceptRejectCutRequest request,
  ) async {
    try {
      final result = await _datasource.acceptRejectCut(request);

      if (result.status != 1) {
        throw Exception(
          result.message ?? 'Error al aceptar o rechazar el corte',
        );
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<TokenGenerateResponse> tokenGenerate(
    TokenGenerateRequest request,
  ) async {
    try {
      final result = await _datasource.tokenGenerate(request);

      if (result.status != 1) {
        throw Exception(result.message ?? 'Error al generar el token');
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<VisitResponse> createVisit(VisitRequest request) async {
    try {
      final result = await _datasource.createVisit(request);

      if (result.status != 1) {
        throw Exception(
          result.message ?? 'Error al crear la visita programada',
        );
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<GetIncidentTypesVisitResponse> incidentTypesByVisit(
    GetIncidentTypesVisitRequest request,
  ) async {
    try {
      final result = await _datasource.incidentTypesByVisit(request);

      return result;
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<ValidVisitStatusResponse> validVisitStatus(
    ValidVisitStatusRequest request,
  ) async {
    try {
      final result = await _datasource.validVisitStatus(request);

      if (result.status != 1 && result.status != 0) {
        throw Exception(result.message ?? 'Ya existe una visita programada');
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<IncidentOpenResponse> incidentOpen(IncidentOpenRequest request) async {
    try {
      final result = await _datasource.incidentOpen(request);

      if (result.status != 1) {
        throw Exception(result.message ?? 'Ya existe una visita programada');
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<GetIncidentResponse> getIncident(GetIncidentRequest request) async {
    try {
      final result = await _datasource.getIncident(request);

      return result;
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<CreateUpdateIncidentResponse> createUpdateIncident(
    CreateUpdateIncidentRequest request,
  ) async {
    try {
      final result = await _datasource.createUpdateIncident(request);

      if (result.status != 1) {
        throw Exception(
          result.message ?? 'Error al crear o actualizar la incidencia',
        );
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<CloseIncidentResponse> closeIncident(
    CloseIncidentRequest request,
  ) async {
    try {
      final result = await _datasource.closeIncident(request);

      if (result.status != 1) {
        throw Exception(result.message ?? 'Error al cerrar la incidencia');
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<GetTargetSalePointResponse> getTargetSalePoint(
    GetTargetSalePointRequest request,
  ) async {
    try {
      final result = await _datasource.getTargetSalePoint(request);

      if (result.status != 1) {
        throw Exception(
          result.message ?? 'Error al obtener el objetivo del punto de venta',
        );
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<GetCylinderSalePointSaleResponse> getCylinderSalePointSale(
    GetCylinderSalePointSaleRequest request,
  ) async {
    try {
      final result = await _datasource.getCylinderSalePointSale(request);

      if (result.status != 1) {
        throw Exception(
          result.message ?? 'Error al obtener las ventas por punto de venta',
        );
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<GetInventoryResponse> getInventory(GetInventoryRequest request) async {
    try {
      final result = await _datasource.getInventory(request);

      if (result.status != 1) {
        throw Exception(
          result.message ?? 'Error al obtener el objetivo del punto de venta',
        );
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<CreateUpdateInventoryResponse> createUpdateInventory(
    CreateUpdateInventoryRequest request,
  ) async {
    try {
      final result = await _datasource.createUpdateInventory(request);

      if (result.status != 1) {
        throw Exception(
          result.message ??
              'Error al crear o actualizar el inventario del punto de venta',
        );
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<ListPendingAuthResponse> listPendingAuth(
    ListPendingAuthRequest request,
  ) async {
    try {
      final result = await _datasource.listPendingAuth(request);

      return result;
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<GetDateResponse> getDate() async {
    try {
      final result = await _datasource.getDate();

      if (result.status != 1) {
        throw Exception(
          result.message ?? 'Error al obtener la fecha del servidor',
        );
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<SearchSalePointResponse> searchSalePoint(
    SearchSalePointRequest request,
  ) async {
    try {
      final result = await _datasource.searchSalePoint(request);
      return result;
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<CreatePhotoIncidentResponse> createPhotoIncident(
    CreatePhotoIncidentRequest request,
  ) async {
    try {
      final result = await _datasource.createPhotoIncident(request);

      if (result.status != 1) {
        throw Exception(
          result.message ?? 'Error al crear la fotografía de incidencia',
        );
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<CreatePhotoIncidentResponse> deletePhotoIncident(
    DeletePhotoIncidentRequest request,
  ) async {
    try {
      final result = await _datasource.deletePhotoIncident(request);

      if (result.status != 1) {
        throw Exception(
          result.message ?? 'Error al eliminar la fotografía de incidencia',
        );
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<GetSupervisorsResponse> getSupervisors(
    GetSupervisorsRequest request,
  ) async {
    try {
      final result = await _datasource.getSupervisors(request);
      return result;
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<CreatePhotoIncidentResponse> changeAuthStatus(
    ChangeAuthStatusRequest request,
  ) async {
    try {
      final result = await _datasource.changeAuthStatus(request);

      if (result.status != 1) {
        throw Exception(
          result.message ??
              'Error al cambiar el estado de la autorización de corte',
        );
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<GetInventoryDifferencesResponse> getInventoryDifferences(
    GetInventoryDifferencesRequest request,
  ) async {
    try {
      final result = await _datasource.getInventoryDifferences(request);

      if (result.status != 1) {
        throw Exception(
          result.message ?? 'Error al obtener las diferencias de inventario',
        );
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<CreatePhotoIncidentResponse> requestAuthCut(
    RequestAuthCutRequest request,
  ) async {
    try {
      final result = await _datasource.requestAuthCut(request);

      if (result.status != 1) {
        throw Exception(
          result.message ?? 'Error al solicitar la autorización de corte',
        );
      } else {
        return result;
      }
    } on AppException catch (e) {
      throw Exception(e.message);
    }
  }
}
