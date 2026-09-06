import '../models/reward_task.dart';

// Placeholder task feed. In production this list is fetched from the
// backend (GET /tasks), not hardcoded — tasks, categories and reward
// amounts are controlled server-side so they can change without an app update.
const sampleRewardTasks = <RewardTask>[
  RewardTask(
    id: 'task-01',
    title: 'Rate an AI response for accuracy',
    description: 'Read a short AI-generated answer and rate it for accuracy and tone.',
    category: 'AI Training',
    rewardNaira: 150,
  ),
  RewardTask(
    id: 'task-02',
    title: 'Confirm a business listing',
    description: 'Check whether a business address and phone number are still correct.',
    category: 'Micro-task',
    rewardNaira: 80,
  ),
  RewardTask(
    id: 'task-03',
    title: 'Rate a short audio clip',
    description: 'Listen to a 20-second clip and rate its mood and audio quality.',
    category: 'Media Review',
    rewardNaira: 100,
  ),
];
