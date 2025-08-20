
class MentorshipModel {
  String program_status;
  String candidateStatus;
  bool applied;
  String register;

  MentorshipModel({
    required this.program_status,
    required this.candidateStatus,
    required this.applied,
    required this.register,
  });

  Map<String, dynamic> toJson() {
    return {
      "program_status": program_status,
      "candidate_status": candidateStatus,
      "applied": applied,
      "register": register,
    };
  }

}
