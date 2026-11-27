// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

// Project imports:
import 'package:app_supervisores_gt/features/scheduled_visits/model/schedule_visits.dart';

class RetrieveScheduledVisitsUserResponse {
  RetrieveScheduledVisitsUserResponse({required this.scheduleVisits});

  factory RetrieveScheduledVisitsUserResponse.fromJson(Json json) {
    return RetrieveScheduledVisitsUserResponse(
      scheduleVisits: json['VisitasProgramadas'] != null
          ? List<ScheduleVisits>.from(
              json['VisitasProgramadas'].map((x) => ScheduleVisits.fromJson(x)),
            )
          : [],
    );
  }

  Json toJson() {
    return {
      'VisitasProgramadas': scheduleVisits.map((x) => x.toJson()).toList(),
    };
  }

  final List<ScheduleVisits> scheduleVisits;
}
