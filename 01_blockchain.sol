pragma solidity >=0.7.0 <=0.8.2;

contract Owned
{
    address private owner;
    
    constructor() 
    {
        owner = msg.sender;
    }
    
    modifier OnlyOwner
    {
        require(
            msg.sender == owner);
        _;
    }
    
    function ChangeOwner(address newOwner) public OnlyOwner
    {
        owner = newOwner;
    }
    
    function GetOwner() public returns (address)
    {
        return owner;
    }
}


contract ROSReestr is Owned 
{
    enum RequestType {NewHome, EditHome}
    uint reqId;
    
    mapping(address => Employee) private employees;
    mapping(address => Owner) private owners;
    mapping(uint => Request) private requests;
    mapping(string => Home) private homes;
    mapping(string => Ownership[]) private ownerships;
    
    struct Ownership
    {
        string homeAddress;
        address owner;
        uint p;
    }

    struct Owner
    {
        string name;
        uint pass_ser;
        uint pass_num;
        uint256 pass_date;
        string phone_number;
    }
    
    struct Employee
    {
        string nameEmpl;
        string position;
        string phone_number;
        bool isset;
    }
    
    struct Request
    {
        uint id;
        RequestType requestType;
        string homeAddr;
        uint homeArea;
        uint homeCost;
        uint result;
    }
    
    struct Home
    {
        string homeAddress;
        uint area;
        uint cost;
    }
    
    
    modifier OnlyEmployee
    {
        require(
            employees[msg.sender].isset != false
            );
            _;
    }
    
    function AddHome(string memory _adr, uint _area, uint _cost) public 
    {
        Home memory h;
        h.homeAddress = _adr;
        h.area = _area;
        h.cost = _cost;
        homes[_adr] = h;
    }
    
    function GetHome(string memory adr) public returns (uint _area, uint _cost)
    {
        return (homes[adr].area, homes[adr].cost);
    }
    
    function AddEmployee(address id, string memory _name, string memory _position, string memory _phoneNumber) public OnlyOwner
    {
        Employee memory emp;
        emp.nameEmpl = _name;
        emp.position = _position;
        emp.phone_number = _phoneNumber;
        emp.isset = true;
        employees[id] = emp;
    }
    
    function GetEmployee(address id) public OnlyEmployee OnlyOwner returns (string memory _name, string memory _position, string memory _phoneNumber)
    {
        return (employees[id].nameEmpl, employees[id].position, employees[id].phone_number);
    }
    
    function EditEmployee(address _id, string memory _newname, string memory _newposition, string memory _newphoneNumber) public OnlyEmployee OnlyOwner
    {
        employees[_id].nameEmpl = _newname;
        employees[_id].position = _newposition;
        employees[_id].phone_number = _newphoneNumber;
    }
   
    function DeleteEmployee(address id) public OnlyOwner
    {
        delete employees[id];
    }
    
    function AddNewHomeRequest(string memory _homeAddress, uint _homeArea, uint _homeCost) public
    {
        Request memory req;
        req.id = reqId;
        req.requestType = RequestType.NewHome;
        req.homeAddr = _homeAddress;
        req.homeArea = _homeArea;
        req.homeCost = _homeCost;
        requests[reqId] = req;
        reqId++;
    }
    
    function GetRequestsList() public OnlyEmployee returns (Request[] memory request)
    {
        request = new Request[](reqId);
        for (uint _i = 0; _i < reqId; _i++){
            request[_i] = requests[_i];
        }
        return request;
    }
}