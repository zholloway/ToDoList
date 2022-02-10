pragma solidity > 0.5.0;
import { ProgressStatus } from "../enums/ProgressStatus.sol";

struct Task {
    uint256 id;
    string content;
    ProgressStatus progressStatus;
    bool isActive;
}