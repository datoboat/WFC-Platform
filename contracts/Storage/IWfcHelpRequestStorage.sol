pragma solidity ^0.5.0;

contract IWfcHelpRequestStorage {
    
    /**
     * @dev setter of the Organization struct  
     */
    function setOrganization(address _organizationAddress, string calldata _dataUrlPropose, uint256 _status, bool _isUnderInvestigation, string calldata _dataUrlInvestigationRequest) external;
    
    /**
     * @dev setter of the Url containing data with proof of identity of the organization
     */
    function setOrganizationUrlPropose(address _organizationAddress, string calldata _dataUrlPropose) external;
    
    /**
     * @dev getter of the Url containing data with proof of identity of the organization
     */ 
    function getOrganizationUrlPropose(address _organizationAddress) public view returns(string memory);
     
    /**
     * @dev setter of the the proof of identity status of organization request
     */  
    function setOrganizationStatus(address _organizationAddress, uint256 _status) external;
     
    /**
     * @dev getter of the the proof of identity status of organization request
     */  
    function getOrganizationStatus(address _organizationAddress) public view returns(uint256);
     
    /**
     * @dev setter of the investigation status of organization
     */
    function setOrganizationUnderInvestigation(address _organizationAddress, bool _isUnderInvestigation) external;
     
    /**
     * @dev getter of the investigation status of organization
     */
    function getOrganizationUnderInvestigation(address _organizationAddress) public view returns (bool);
     
    /**
     * @dev setter of the Url containing data with proof of identity for blocking address
     */
    function setOrganizationUrlInvestigation(address _organizationAddress, string calldata _dataUrlInvestigationRequest) external;
     
    /**
     * @dev getter of the Url containing data with proof of identity for blocking address
     */
    function getOrganizationUrlInvestigation(address _organizationAddress) public view returns(string memory);
     
    /**
      * @dev setter of the fundraising proposal struct
      */
    function addFundraisingProposal(bytes32 _line, address _organization, uint256 _softcap, uint256 _hardcap, address _currency, uint256 _timeout, address _destination, uint256 _proposalStatus, string calldata _fundraisingDataUrl) external returns(uint256);
    
    /**
     * @dev setter of line of the fundraising line
     */
    function setFundraisingLine(uint256 _index, bytes32 _line) external;
    
    /**
     * @dev getter of line of the fundraising line
     */
    function getFundraisingLine(uint256 _index) public view returns(bytes32);
    
    /**
     * @dev setter of line of the fundraising organization
     */
    function setFundraisingOrganization(uint256 _index, address _organization) external;
    
    /**
     * @dev getter of line of the fundraising organization
     */
    function getFundraisingOrganization(uint256 _index) public view returns(address);
    
    /**
     * @dev setter of line of the fundraising softcap 
     */
    function setFundraisingSoftcap(uint256 _index, uint256 _softcap) external;
    
    /**
     * @dev getter of line of the fundraising softcap
     */
    function getFundraisingSoftcap(uint256 _index) public view returns(uint256);
    
    /**
     * @dev setter of line of the fundraising hardcap 
     */
    function setFundraisingHardcap(uint256 _index, uint256 _hardcap) external;
    
    /**
     * @dev getter of line of the fundraising hardcap
     */
    function getFundraisingHardcap(uint256 _index) public view returns(uint256);
    
     /**
     * @dev setter of line of the fundraising token
     */
    function setFundraisingToken(uint256 _index, address _token) external;
    
    /**
     * @dev getter of line of the fundraising token
     */
    function getFundraisingToken(uint256 _index) public view returns(address);
    
    /**
     * @dev setter of line of the fundraising timeout
     */
    function setFundraisingTimeout(uint256 _index, uint256 _timeout) external;
    
    /**
     * @dev getter of line of the fundraising timeout
     */
    function getFundraisingTimeout(uint256 _index) public view returns(uint256);
    
    /**
     * @dev setter of line of the fundraising destination
     */
    function setFundraisingDestination(uint256 _index, address _destination) external;
    
    /**
     * @dev getter of line of the fundraising destination
     */
    function getFundraisingDestination(uint256 _index) public view returns(address);
    
    /**
     * @dev setter of line of the fundraising status
     */
    function setFundraisingStatus(uint256 _index, uint256 _status) external;
    
    /**
     * @dev getter of line of the fundraising status
     */
    function getFundraisingStatus(uint256 _index) public view returns(uint256);
    
    /**
     * @dev setter of line of the fundraising url
     */
    function setFundraisingDataUrl(uint256 _index, string calldata _fundraisingDataUrl) external;
    
    /**
     * @dev getter of line of the fundraising url
     */
    function getFundraisingDataUrl(uint256 _index) public view returns(string memory);
    
}
