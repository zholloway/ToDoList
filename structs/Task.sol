pragma solidity > 0.5.0;

struct Task {
    uint256 id;
    string content;
    ProgressStatus progressStatus;
    bool isActive;
}

enum ProgressStatus {
    New,
    InProgress,
    Complete
}