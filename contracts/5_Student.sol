// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract StudentRegistry {
    enum Attendance { Absent, Present }
    
    struct Student {
        string name;
        Attendance attendance;
        string[] interests;
    }

    mapping(address => Student) private students;
    
    event StudentCreated(address indexed studentAddress, string name);
    event AttendanceMarked(address indexed studentAddress, Attendance attendance);
    event InterestAdded(address indexed studentAddress, string interest);
    
    modifier onlyNewStudent() {
        require(bytes(students[msg.sender].name).length == 0, "Student already registered");
        _;
    }
    
    modifier studentExists(address _studentAddress) {
        require(bytes(students[_studentAddress].name).length > 0, "Student not registered");
        _;
    }

    function registerStudent() public onlyNewStudent {
        students[msg.sender] = Student({
            name: "Default Name",
            attendance: Attendance.Absent,
            interests: new string[](0)
        });
        emit StudentCreated(msg.sender, "Default Name");
    }
    
    function registerNewStudent(string memory _name) public onlyNewStudent {
        require(bytes(_name).length > 0, "Name cannot be empty");
        students[msg.sender] = Student({
            name: _name,
            attendance: Attendance.Absent,
            interests: new string[](0)
        });
        emit StudentCreated(msg.sender, _name);
    }
    
    function markAttendance(address _studentAddress, Attendance _attendance) public studentExists(_studentAddress) {
        students[_studentAddress].attendance = _attendance;
        emit AttendanceMarked(_studentAddress, _attendance);
    }
    
    function addInterest(address _studentAddress, string memory _interest) public studentExists(_studentAddress) {
        require(bytes(_interest).length > 0, "Interest cannot be empty");
        require(students[_studentAddress].interests.length < 5, "Maximum of 5 interests allowed");
        
        for (uint i = 0; i < students[_studentAddress].interests.length; i++) {
            require(keccak256(bytes(students[_studentAddress].interests[i])) != keccak256(bytes(_interest)), "Interest already exists");
        }
        
        students[_studentAddress].interests.push(_interest);
        emit InterestAdded(_studentAddress, _interest);
    }
    
    function getStudent(address _studentAddress) public view studentExists(_studentAddress) returns (string memory, Attendance, string[] memory) {
        Student storage student = students[_studentAddress];
        return (student.name, student.attendance, student.interests);
    }
}
