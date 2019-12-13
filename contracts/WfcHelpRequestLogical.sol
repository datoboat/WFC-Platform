pragma solidity ^0.5.0;

import "./utils/StringAsKey.sol";

import "./Registry/IWfcRegistry.sol";

import "./storage/IWfcHelpRequestStorage.sol";

import "./storage/IWfcManagmentStorage.sol";

contract IWfcDonationsStorage {
    function createFundraising(bytes32 _line, address _organization, uint256 _softcap, uint256 _hardcap, address _currency, uint256 _timeout, address _destination, string calldata _metadata) external;
}

contract IWfcReserveStorage {
    function() external payable {
    }
}


contract WfcHelpRequestOrganizationsLogical {
    
    using StringAsKey for string;

    /**
     * @dev address of the registry this contract is linked to
     */
    IWfcRegistry public wfcRegistry;

    /**
     * @dev name in bytes of storage contracts that this contract is linked through the registry
     */
    bytes32[4] public storageContractName;
    
    enum StatusRegistration {NOT_EXISTING, PROPOSED, APPROVED, REFUSED, REVOKED, BLOCKED}
    
    
    event RegistrationRequestLog(address indexed _organizationAddress, string _dataUrl);
    
    event RegistrationApproved(address indexed _organizationAddress);
    
    event RegistrationRefused(address indexed _organizationAddress);
    
    event RegistrationRevoked(address indexed _organizationAddress);
    
    event RegitrationChanged(address indexed _previousAddress, address indexed _newAddress);
    
    event RegistrationBlocked(address indexed _organizationAddress);
    
    event RequireDaoInvestigationLog(address indexed _organizationAddress, string _investigationDataUrl);
    
    event InvestigationStop(address indexed _organizationAddress);
    
    modifier onlyOwnerDao {
        require(msg.sender == wfcRegistry.getOwnerDao(), "Sender different from Dao owner");
        _;
    }

    function registrationRequest(string calldata _dataUrl, address _organizationAddress) external {
        IWfcHelpRequestStorage wfcHelpRequestStorage = IWfcHelpRequestStorage(wfcRegistry.storageContracts(storageContractName[0]));
        require(wfcHelpRequestStorage.getOrganizationStatus(_organizationAddress) == uint256(StatusRegistration.NOT_EXISTING), "Organization already proposed");
        wfcHelpRequestStorage.setOrganization(_organizationAddress, _dataUrl, uint256(StatusRegistration.PROPOSED), false, "");
        emit RegistrationRequestLog(_organizationAddress, _dataUrl);
    }
    
    function approveRequest(address _organizationAddress) external onlyOwnerDao() {
        IWfcHelpRequestStorage wfcHelpRequestStorage = IWfcHelpRequestStorage(wfcRegistry.storageContracts(storageContractName[0]));
        require(wfcHelpRequestStorage.getOrganizationStatus(_organizationAddress) == uint256(StatusRegistration.PROPOSED), "Organization not proposed");
        wfcHelpRequestStorage.setOrganizationStatus(_organizationAddress, uint256(StatusRegistration.APPROVED));
        emit RegistrationApproved(_organizationAddress);
    }
    
    function refuseRequest(address _organizationAddress) external onlyOwnerDao() {
        IWfcHelpRequestStorage wfcHelpRequestStorage = IWfcHelpRequestStorage(wfcRegistry.storageContracts(storageContractName[0]));
        require(wfcHelpRequestStorage.getOrganizationStatus(_organizationAddress) == uint256(StatusRegistration.PROPOSED), "Organization not proposed");
        wfcHelpRequestStorage.setOrganizationStatus(_organizationAddress, uint256(StatusRegistration.REFUSED));
        emit RegistrationRefused(_organizationAddress);
    }
    
    function revokeAddress() external {
        IWfcHelpRequestStorage wfcHelpRequestStorage = IWfcHelpRequestStorage(wfcRegistry.storageContracts(storageContractName[0]));
        require(wfcHelpRequestStorage.getOrganizationStatus(msg.sender) == uint256(StatusRegistration.APPROVED), "Organization not approved");
        wfcHelpRequestStorage.setOrganizationStatus(msg.sender, uint256(StatusRegistration.REVOKED));
        emit RegistrationRevoked(msg.sender);
    }
    
    function changeAddress(address _newOrganizationAddress) external {
        IWfcHelpRequestStorage wfcHelpRequestStorage = IWfcHelpRequestStorage(wfcRegistry.storageContracts(storageContractName[0]));
        require(wfcHelpRequestStorage.getOrganizationStatus(msg.sender) == uint256(StatusRegistration.APPROVED), "Organization not approved");
        require(!wfcHelpRequestStorage.getOrganizationUnderInvestigation(msg.sender), "Organization is under investigation");
        require(wfcHelpRequestStorage.getOrganizationStatus(_newOrganizationAddress) == uint256(StatusRegistration.NOT_EXISTING), "Organization already proposed");
        string memory dataUrlPropose = wfcHelpRequestStorage.getOrganizationUrlPropose(msg.sender);
        wfcHelpRequestStorage.setOrganization(_newOrganizationAddress, dataUrlPropose, uint256(StatusRegistration.APPROVED), false, "");
        wfcHelpRequestStorage.setOrganizationStatus(msg.sender, uint256(StatusRegistration.REVOKED));
        emit RegistrationRevoked(msg.sender);
        emit RegistrationRequestLog(_newOrganizationAddress, dataUrlPropose);
        emit RegistrationApproved(_newOrganizationAddress);
    }
    
    function requireDaoInvestigation(string calldata _investigationDataUrl, address _organizationAddress) external payable {
        IWfcHelpRequestStorage wfcHelpRequestStorage = IWfcHelpRequestStorage(wfcRegistry.storageContracts(storageContractName[0]));
        IWfcManagmentStorage wfcManagment = IWfcManagmentStorage(wfcRegistry.storageContracts(storageContractName[3]));
        string memory setting = "InvestigationCost";
        bytes32 settingData = setting.convert();
        require(msg.value > wfcManagment.getSettings(settingData), "Not enough eth for investigation");
        require(wfcHelpRequestStorage.getOrganizationStatus(_organizationAddress) == uint256(StatusRegistration.APPROVED), "Organization not approved");
        require(!wfcHelpRequestStorage.getOrganizationUnderInvestigation(_organizationAddress), "Organization already under investigation");
        wfcHelpRequestStorage.setOrganizationUnderInvestigation(_organizationAddress, true);
        wfcHelpRequestStorage.setOrganizationUrlInvestigation(_organizationAddress, _investigationDataUrl);
        IWfcReserveStorage wfcReserveStorage = IWfcReserveStorage(wfcRegistry.storageContracts(storageContractName[2]));
        address(wfcReserveStorage).transfer(msg.value);
        emit RequireDaoInvestigationLog(_organizationAddress, _investigationDataUrl);
    }
    
    function voteDaoInvestigation(address _organizationAddress, bool _isBlocked) external onlyOwnerDao() {
        IWfcHelpRequestStorage wfcHelpRequestStorage = IWfcHelpRequestStorage(wfcRegistry.storageContracts(storageContractName[0]));
        require(wfcHelpRequestStorage.getOrganizationStatus(_organizationAddress) == uint256(StatusRegistration.APPROVED), "Organization not approved");
        require(wfcHelpRequestStorage.getOrganizationUnderInvestigation(_organizationAddress), "Organization is not under investigation");
        if (_isBlocked) {
            wfcHelpRequestStorage.setOrganizationStatus(_organizationAddress, uint256(StatusRegistration.BLOCKED));
            emit RegistrationBlocked(_organizationAddress);
        } else {
            wfcHelpRequestStorage.setOrganizationUnderInvestigation(_organizationAddress, false);
            wfcHelpRequestStorage.setOrganizationUrlInvestigation(_organizationAddress, "");
            emit InvestigationStop(_organizationAddress);
        }
    }
    
    function blockHackedAddress(address _newOrganizationAddress) external {
        IWfcHelpRequestStorage wfcHelpRequestStorage = IWfcHelpRequestStorage(wfcRegistry.storageContracts(storageContractName[0]));
        require(wfcHelpRequestStorage.getOrganizationStatus(msg.sender) == uint256(StatusRegistration.REVOKED), "Organization sender not revoked");
        require(wfcHelpRequestStorage.getOrganizationStatus(_newOrganizationAddress) == uint256(StatusRegistration.APPROVED), "Hacker organization not approved");
        require(keccak256(abi.encodePacked(wfcHelpRequestStorage.getOrganizationUrlPropose(msg.sender))) == keccak256(abi.encodePacked(wfcHelpRequestStorage.getOrganizationUrlPropose(_newOrganizationAddress))), "Different identities");
        wfcHelpRequestStorage.setOrganizationStatus(_newOrganizationAddress, uint256(StatusRegistration.BLOCKED));
        emit RegistrationBlocked(msg.sender);
    }
    
}


contract WfcHelpRequestLogical is WfcHelpRequestOrganizationsLogical {
    
    enum StatusProposal {PROPOSED, REVOKED, REFUSED, APPROVED}
    
    event FundraisingSubmittedLog(uint256 indexed _fundraisingId, string indexed _line, address indexed _organization, uint256 _softcap, uint256 _hardcap, address _currency, uint256 _timeout, address _destination, string _metadata);
    
    event FundraisingRevokedLog(uint256 indexed _fundraisingId);
    
    event FundraisingRefusedLog(uint256 indexed _fundraisingId);
    
    event FundraisingApprovedLog(uint256 indexed _fundraisingId);
    
    event FundraisingCreatedLog(uint256 indexed _line, uint256 indexed _fundraisingId, address indexed _organization, uint256 _softcap, uint256 _hardcap, uint256 _reserveSplit, uint256 _serviceLineSplit, uint256 _allLinesSplit, uint256 _teamSplit, address _currency, uint256 _timeout, address _destination, string _metadata);
    

    constructor(IWfcRegistry _wfcRegistry, string memory _helpRequestContractName, string memory _donationContractName, string memory _managmentContractName, string memory _reserveContractName) public {
        require(address(_wfcRegistry) != address(0), "Registry address is null");
        wfcRegistry = _wfcRegistry;
        storageContractName[0] = _helpRequestContractName.convert();
        storageContractName[1] = _donationContractName.convert();
        storageContractName[2] = _managmentContractName.convert();
        storageContractName[3] = _reserveContractName.convert();
    }
    
    function submitFundraising(string calldata _line, uint256 _softcap, uint256 _hardcap, address _tokenAddress, uint256 _timeout, address _destination, string calldata _dataUrl) external {
        IWfcHelpRequestStorage wfcHelpRequestStorage = IWfcHelpRequestStorage(wfcRegistry.storageContracts(storageContractName[0]));
        IWfcManagmentStorage wfcManagment = IWfcManagmentStorage(wfcRegistry.storageContracts(storageContractName[3]));
        require(wfcHelpRequestStorage.getOrganizationStatus(msg.sender) == uint256(StatusRegistration.APPROVED), "Organization not registred");
        bytes32 line = _line.convert();
        require(wfcManagment.getServiceLine(line) == true, "Wrong service Line");
        require(wfcManagment.getTokenAddress(_tokenAddress) == true, "Wrong token");
        require(_destination != address(0), "Destination address must be different from zero address");
        uint256 propNumber = wfcHelpRequestStorage.addFundraisingProposal(line, msg.sender, _softcap, _hardcap, _tokenAddress, _timeout, _destination, uint256(StatusProposal.PROPOSED), _dataUrl);
        emit FundraisingSubmittedLog(propNumber - 1, _line, msg.sender, _softcap, _hardcap, _tokenAddress, _timeout, _destination, _dataUrl);
    }
    
    function revokeFundraising(uint256 _fundraisingId) external {
        IWfcHelpRequestStorage wfcHelpRequestStorage = IWfcHelpRequestStorage(wfcRegistry.storageContracts(storageContractName[0]));
        require(msg.sender == wfcHelpRequestStorage.getFundraisingOrganization(_fundraisingId), "Wrong organization");
        require(wfcHelpRequestStorage.getFundraisingStatus(_fundraisingId) == uint256(StatusProposal.PROPOSED), "Wrong status of proposal");
        wfcHelpRequestStorage.setFundraisingStatus(_fundraisingId, uint256(StatusProposal.REVOKED));
        emit FundraisingRevokedLog(_fundraisingId);
    }
    
    function refuseFundraising(uint256 _fundraisingId) external onlyOwnerDao() {
        IWfcHelpRequestStorage wfcHelpRequestStorage = IWfcHelpRequestStorage(wfcRegistry.storageContracts(storageContractName[0]));
        require(wfcHelpRequestStorage.getFundraisingStatus(_fundraisingId) == uint256(StatusProposal.PROPOSED), "Wrong status of proposal");
        wfcHelpRequestStorage.setFundraisingStatus(_fundraisingId, uint256(StatusProposal.REFUSED));
        emit FundraisingRefusedLog(_fundraisingId);
    }
    
    function approveFundraising(uint256 _fundraisingId) external onlyOwnerDao() {
        IWfcHelpRequestStorage wfcHelpRequestStorage = IWfcHelpRequestStorage(wfcRegistry.storageContracts(storageContractName[0]));
        IWfcDonationsStorage wfcDonationsStorage = IWfcDonationsStorage(wfcRegistry.storageContracts(storageContractName[1]));
        require(wfcHelpRequestStorage.getFundraisingStatus(_fundraisingId) == uint256(StatusProposal.PROPOSED), "Wrong status of proposal");
        wfcHelpRequestStorage.setFundraisingStatus(_fundraisingId, uint256(StatusProposal.APPROVED));
        emit FundraisingApprovedLog(_fundraisingId);
        wfcDonationsStorage.createFundraising(wfcHelpRequestStorage.getFundraisingLine(_fundraisingId), wfcHelpRequestStorage.getFundraisingOrganization(_fundraisingId), wfcHelpRequestStorage.getFundraisingSoftcap(_fundraisingId), wfcHelpRequestStorage.getFundraisingHardcap(_fundraisingId), wfcHelpRequestStorage.getFundraisingToken(_fundraisingId), wfcHelpRequestStorage.getFundraisingTimeout(_fundraisingId), wfcHelpRequestStorage.getFundraisingDestination(_fundraisingId), wfcHelpRequestStorage.getFundraisingDataUrl(_fundraisingId));
    }
}