// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Model {

  struct StudentStruct {
    string Name;
    bool Attendance;
    string[5] Interests;
  }

    address public owner;

  StudentStruct public student;

  mapping(address => StudentStruct) public studentMap;

  function addStudent()  public {

    string memory _Name = "Collins";
    bool  _Attendance = false;
    string[5] memory _Interest = ["1", "2", "3", "4", "5"];

    studentMap[msg.sender] = StudentStruct(_Name, _Attendance, _Interest);
  }

  function getStudent(address _addr) public view returns (StudentStruct memory) {
    return studentMap[_addr];
  }

  // A function that allow a student to register his/herself
  function addSelfStudent(string memory _Name, bool _Attendance, string[5] memory _Interest) public {
    studentMap[msg.sender] = StudentStruct(_Name, _Attendance, _Interest);
  }

  // on the contract owner can add student
  function ownerAddStudent(address _studentAddr, string memory _Name, bool _Attendance, string[5] memory _Interest) public {
    require(msg.sender == owner, "Only the contract owner can call this function.");
    studentMap[_studentAddr] = StudentStruct(_Name, _Attendance, _Interest);
  }

}