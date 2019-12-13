pragma solidity ^0.5.0;

import "../Registry/IWfcRegistry.sol";

import "./IWfcHelpRequestStorage.sol";

/**
 * @dev Storage contract implementing all getter and setter of the variables 
 *  of help request that work as a decentrlized filter for organizations and fundraisings
 */

contract WfcHelpRequestStorage is IWfcHelpRequestStorage {
    
    /**
     * @dev address of the registry this contract is linked to
     */
    IWfcRegistry public wfcRegistry;
    
    enum StatusRegistration {NOT_EXISTING, PROPOSED, APPROVED, REFUSED, REVOKED, BLOCKED}
    
    struct OrganziationRef {
        string dataUrlPropose;
        StatusRegistration status;
        bool isUnderInvestigation;
        string dataUrlInvestigationRequest;
    }
    
    /**
     * @dev mapping that associate an Eth address to an organization
     */
    mapping(address => OrganziationRef) public organizations;
    
    enum StatusProposal {PROPOSED, REVOKED, REFUSED, APPROVED}
    
    struct FundraisingProposal {
        bytes32 line;
        address organization;
        uint256 softcap;
        uint256 hardcap;
        address currency;
        uint256 timeout;
        address destination;
        StatusProposal proposalStatus;
        string fundraisingDataUrl;
    }
    
    /**
     * @dev array that contains all fundraising proposal by registred organizations
     */
    FundraisingProposal[] public proposals;
    
    modifier onlyAllowedLogicalContract {
        require(wfcRegistry.isAllowed(address(this), msg.sender), "Sender is not allowed");
        _;
    }
    
    /**
     * @dev constructor that sets the address of the registry
     */
    constructor(IWfcRegistry _wfcRegistry) public {
        require(address(_wfcRegistry) != address(0), "Registry address is null");
        wfcRegistry = _wfcRegistry;
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-setOrganization}
     */
    function setOrganization(address _organizationAddress, string calldata _dataUrlPropose, uint256 _status, bool _isUnderInvestigation, string calldata _dataUrlInvestigationRequest) external onlyAllowedLogicalContract {
        organizations[_organizationAddress] = OrganziationRef(_dataUrlPropose, StatusRegistration(_status), _isUnderInvestigation, _dataUrlInvestigationRequest);
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-setOrganizationUrlPropose}
     */
    function setOrganizationUrlPropose(address _organizationAddress, string calldata _dataUrlPropose) external onlyAllowedLogicalContract {
        organizations[_organizationAddress].dataUrlPropose = _dataUrlPropose;
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-getOrganizationUrlPropose}
     */ 
    function getOrganizationUrlPropose(address _organizationAddress) public view returns(string memory) {
        return organizations[_organizationAddress].dataUrlPropose;
    }
     
    /**
     * @dev See {IWfcHelpRequestStorage-setOrganizationStatus}
     */  
    function setOrganizationStatus(address _organizationAddress, uint256 _status) external onlyAllowedLogicalContract {
        organizations[_organizationAddress].status = StatusRegistration(_status);
    }
     
    /**
     * @dev See {IWfcHelpRequestStorage-getOrganizationStatus}
     */  
    function getOrganizationStatus(address _organizationAddress) public view returns(uint256) {
        return uint256(organizations[_organizationAddress].status);
    }
     
    /**
     * @dev See {IWfcHelpRequestStorage-setOrganizationUnderInvestigation}
     */
    function setOrganizationUnderInvestigation(address _organizationAddress, bool _isUnderInvestigation) external onlyAllowedLogicalContract {
        organizations[_organizationAddress].isUnderInvestigation = _isUnderInvestigation;
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-getOrganizationUnderInvestigation}
     */
    function getOrganizationUnderInvestigation(address _organizationAddress) public view returns (bool) {
        return organizations[_organizationAddress].isUnderInvestigation;
    }
     
    /**
     * @dev See {IWfcHelpRequestStorage-setOrganizationUrlInvestigation}
     */
    function setOrganizationUrlInvestigation(address _organizationAddress, string calldata _dataUrlInvestigationRequest) external onlyAllowedLogicalContract {
        organizations[_organizationAddress].dataUrlInvestigationRequest = _dataUrlInvestigationRequest;
    }
     
    /**
     * @dev See {IWfcHelpRequestStorage-getOrganizationUrlInvestigation}
     */
    function getOrganizationUrlInvestigation(address _organizationAddress) public view returns(string memory) {
        return organizations[_organizationAddress].dataUrlInvestigationRequest;
    }
     
    /**
      * @dev See {IWfcHelpRequestStorage-addFundraisingProposal}
      */
    function addFundraisingProposal(bytes32 _line, address _organization, uint256 _softcap, uint256 _hardcap, address _currency, uint256 _timeout, address _destination, uint256 _proposalStatus, string calldata _fundraisingDataUrl) external onlyAllowedLogicalContract returns(uint256) {
        uint256 length = proposals.push(FundraisingProposal(_line, _organization, _softcap, _hardcap, _currency, _timeout, _destination, StatusProposal(_proposalStatus), _fundraisingDataUrl));
        return length;
    }
    
    /**
      * @dev See {IWfcHelpRequestStorage-setFundraisingLine}
      */
    function setFundraisingLine(uint256 _index, bytes32 _line) external onlyAllowedLogicalContract {
        proposals[_index].line = _line;
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-getFundraisingLine}
     */
    function getFundraisingLine(uint256 _index) public view returns(bytes32) {
        return proposals[_index].line;
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-setFundraisingOrganization}
     */
    function setFundraisingOrganization(uint256 _index, address _organization) external onlyAllowedLogicalContract {
        proposals[_index].organization = _organization;
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-getFundraisingOrganization}
     */
    function getFundraisingOrganization(uint256 _index) public view returns(address) {
        return proposals[_index].organization;
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-setFundraisingSoftcap}
     */
    function setFundraisingSoftcap(uint256 _index, uint256 _softcap) external onlyAllowedLogicalContract {
        proposals[_index].softcap = _softcap;
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-getFundraisingSoftcap}
     */
    function getFundraisingSoftcap(uint256 _index) public view returns(uint256) {
        return proposals[_index].softcap;
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-setFundraisingHardcap}
     */
    function setFundraisingHardcap(uint256 _index, uint256 _hardcap) external onlyAllowedLogicalContract {
        proposals[_index].hardcap = _hardcap;
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-getFundraisingHardcap}
     */
    function getFundraisingHardcap(uint256 _index) public view returns(uint256) {
        return proposals[_index].hardcap;
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-setFundraisingToken}
     */
    function setFundraisingToken(uint256 _index, address _token) external onlyAllowedLogicalContract {
        proposals[_index].currency = _token;
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-setFundraisingToken}
     */
    function getFundraisingToken(uint256 _index) public view returns(address) {
        return proposals[_index].currency;
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-setFundraisingTimeout}
     */
    function setFundraisingTimeout(uint256 _index, uint256 _timeout) external onlyAllowedLogicalContract {
        proposals[_index].timeout = _timeout;
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-getFundraisingTimeout}
     */
    function getFundraisingTimeout(uint256 _index) public view returns(uint256) {
        return proposals[_index].timeout;
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-setFundraisingDestination}
     */
    function setFundraisingDestination(uint256 _index, address _destination) external onlyAllowedLogicalContract {
        proposals[_index].destination = _destination;
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-getFundraisingDestination}
     */
    function getFundraisingDestination(uint256 _index) public view returns(address) {
        return proposals[_index].destination;
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-setFundraisingStatus}
     */
    function setFundraisingStatus(uint256 _index, uint256 _status) external onlyAllowedLogicalContract {
        proposals[_index].proposalStatus = StatusProposal(_status);
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-getFundraisingStatus}
     */
    function getFundraisingStatus(uint256 _index) public view returns(uint256) {
        return uint256(proposals[_index].proposalStatus);
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-setFundraisingDataUrl}
     */
    function setFundraisingDataUrl(uint256 _index, string calldata _fundraisingDataUrl) external onlyAllowedLogicalContract {
        proposals[_index].fundraisingDataUrl = _fundraisingDataUrl;
    }
    
    /**
     * @dev See {IWfcHelpRequestStorage-getFundraisingDataUrl}
     */
    function getFundraisingDataUrl(uint256 _index) public view returns(string memory) {
        return proposals[_index].fundraisingDataUrl;
    }
    
}