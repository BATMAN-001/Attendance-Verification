// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AttendanceSystem {

    address public admin;
    uint256 public maxAttendanceCount = 100; // Maximum attendance limit
    mapping(address => bool) public registeredStudents;
    mapping(address => uint256) public attendanceCount;

    event AttendanceMarked(address student, uint256 timestamp);
    event StudentRegistration(address student, bool registered);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyRegisteredStudent() {
        require(registeredStudents[msg.sender], "Not a registered student");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerStudent(address student) external onlyAdmin {
        registeredStudents[student] = true;
        emit StudentRegistration(student, true);
    }

    function markAttendance() external onlyRegisteredStudent {
        require(attendanceCount[msg.sender] < maxAttendanceCount, "Attendance limit reached");
        attendanceCount[msg.sender]++;
        emit AttendanceMarked(msg.sender, block.timestamp);
    }

    function getAttendanceCount(address student) external view returns (uint256) {
        return attendanceCount[student];
    }

    function setMaxAttendanceCount(uint256 count) external onlyAdmin {
        maxAttendanceCount = count;
    }
}
