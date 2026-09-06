enum TaskStatus { available, submitted, verified, rejected }

class RewardTask {
  final String id;
  final String title;
  final String description;
  final String category; // e.g. 'AI Training', 'Micro-task', 'Media Review'
  final int rewardNaira;
  final TaskStatus status;

  const RewardTask({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.rewardNaira,
    this.status = TaskStatus.available,
  });

  RewardTask copyWith({TaskStatus? status}) {
    return RewardTask(
      id: id,
      title: title,
      description: description,
      category: category,
      rewardNaira: rewardNaira,
      status: status ?? this.status,
    );
  }
}
