pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see `ERC20Detailed`.
 */
interface ERC20Token {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


interface Donation {
    
    function transferDonationEth(uint256 _line, uint256 _fundraisingId) external payable;
    
    function transferDonationTokens(uint256 _line, uint256 _fundraisingId, uint256 _amount) external;
    
    function transferWarrantyEth(uint256 _line, uint256 _fundraisingId) external payable;
    
    function transferWarrantyTokens(uint256 _line, uint256 _fundraisingId, uint256 _amount) external;
}

interface Reserve {
    
    function transferReserveEth(uint256 _line, uint256 _fundraisingId) external payable;
    
    function transferReserveTokens(uint256 _line, uint256 _fundraisingId, uint256 _amount) external;
}

interface ServiceLine {
    
    function transferServiceLineEth(uint256 _line, uint256 _fundraisingId) external payable;
    
    function transferServiceLineTokens(uint256 _line, uint256 _fundraisingId, uint256 _amount) external;
}

interface AllLines{
    
    function transferAllLinesEth(uint256 _line, uint256 _fundraisingId) external payable;
    
    function transferAllLinesTokens(uint256 _line, uint256 _fundraisingId, uint256 _amount) external;
}

interface Team{
    
    function transferTeamEth(uint256 _line, uint256 _fundraisingId) external payable;
    
    function transferTeamTokens(uint256 _line, uint256 _fundraisingId, uint256 _amount) external;
}



contract OwnableDao {
    address internal ownerDao;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor (address _ownerDao) internal {
        require (_ownerDao!=address(0));
        ownerDao = _ownerDao;
        emit OwnershipTransferred(address(0), _ownerDao);
    }



    /**
     * @return the address of the owner.
     */
    function getOwnerDao() public view returns (address) {
        return ownerDao;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwnerDao() {
        require(isOwnerDao());
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwnerDao() public view returns (bool) {
        return msg.sender == ownerDao;
    }

   
    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwnerDao The address to transfer ownership to.
     */
    function transferOwnershipDao(address newOwnerDao) public onlyOwnerDao {
        _transferOwnershipDao(newOwnerDao);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwnerDao The address to transfer ownership to.
     */
    function _transferOwnershipDao(address newOwnerDao) internal {
        require(newOwnerDao != address(0));
        emit OwnershipTransferred(ownerDao, newOwnerDao);
        ownerDao = newOwnerDao;
    }
}

contract SupportedTokens is OwnableDao  {
  mapping(address => bool) public tokenAddress;
  
  modifier notZeroAddress(address _address) {
      require(_address != address(0), 'zero address not allowed');
      _;
  }
  
  constructor (address[] memory _tokensAddress) internal {
      for (uint i =  0; i < _tokensAddress.length; i++) {
        _setToken(true, _tokensAddress[i]);
      }
  }

  function setToken (bool _isActivated, address _tokenAddress) external onlyOwnerDao {
        _setToken(_isActivated, _tokenAddress);
  }
  
  function _setToken(bool _isActivated, address _tokenAddress) internal notZeroAddress(_tokenAddress) {
        tokenAddress[_tokenAddress] = _isActivated;
  }
}

contract SupportedLines is OwnableDao  {
  mapping(uint256 => bool) public serviceLines;
  
  constructor (uint256 _numberLines) internal {
      for (uint i =0; i < _numberLines; i++) {
         serviceLines[i] = true; 
      }
  }

  function setLine (uint256 _index, bool _isActivated) external onlyOwnerDao {
      serviceLines[_index] = _isActivated ;
  }
}

contract DonationSplit is OwnableDao {

    uint256 reserveSplit;
    uint256 serviceLineSplit;
    uint256 allLinesSplit;
    uint256 teamSplit;
    
    constructor(uint256[4] memory _split) internal {
        reserveSplit = _split[0];    
        serviceLineSplit = _split[1];
        allLinesSplit = _split[2];
        teamSplit = _split[3];
    }
    
    modifier correctSplit() {
        require (reserveSplit + serviceLineSplit + allLinesSplit + teamSplit < 10000, 'reserve percent too high');
        _;
    }
    
    function setReserveSplit(uint256 _reserveSplit) external onlyOwnerDao correctSplit {
        reserveSplit = _reserveSplit;
    }
    
    function setServiceLineSplit(uint256 _serviceLineSplit) external onlyOwnerDao correctSplit {
        serviceLineSplit = _serviceLineSplit;
    }
    
    function setAllLinesSplit(uint256 _allLinesSplit) external onlyOwnerDao correctSplit {
        allLinesSplit = _allLinesSplit;
    }
    
    function setTeamSplit(uint256 _teamSplit) external onlyOwnerDao correctSplit {
        teamSplit = _teamSplit;
    }
}

contract SplitContracts is OwnableDao  {
    Donation donationContract;
    Reserve reserveContract;
    ServiceLine serviceLineContract;
    AllLines allLinesContract;
    Team teamContract;
    
    modifier notZeroAddress(address _address) {
      require(_address != address(0), 'zero address not allowed');
      _;
  }
    
    constructor(Donation _donationContract, Reserve _reserveContract, ServiceLine _serviceLineContract, AllLines _allLinesContract, Team _teamContract) 
        internal 
        notZeroAddress(address(_donationContract))
        notZeroAddress(address(_reserveContract)) 
        notZeroAddress(address(_serviceLineContract))
        notZeroAddress(address(_allLinesContract))
        notZeroAddress(address(_teamContract))
    {
        donationContract = _donationContract;
        reserveContract = _reserveContract;
        serviceLineContract = _serviceLineContract;
        allLinesContract = _allLinesContract;
        teamContract = _teamContract;
    }
    
    function setDonationContract(Donation _donationContract) external onlyOwnerDao notZeroAddress(address(_donationContract)) {
        donationContract = _donationContract;
    } 
    
    function setReserveContract(Reserve _reserveContract) external onlyOwnerDao notZeroAddress(address(_reserveContract)) {
        reserveContract = _reserveContract;
    } 
    
    function setServiceLineContract(ServiceLine _serviceLineContract) external onlyOwnerDao notZeroAddress(address(_serviceLineContract)) {
        serviceLineContract = _serviceLineContract;
    } 
    
    function setAllLinesContract(AllLines _allLinesContract) external onlyOwnerDao notZeroAddress(address(_allLinesContract)) {
        allLinesContract = _allLinesContract;
    } 

    function setTeamContract(Team _teamContract) external onlyOwnerDao notZeroAddress(address(_teamContract)) {
        teamContract = _teamContract;
    } 
}

contract WfcPlatformRegistrations is SupportedTokens, SupportedLines, DonationSplit, SplitContracts {
    
    enum StatusRegistration {PROPOSED, APPROVED, REFUSED, REVOKED, BLOCKED}
    
    struct OrganziationRef {
        string dataUrl;
        StatusRegistration status;
    }
    
    mapping(address => OrganziationRef) public organizations;
    
    
    function registrationRequest(string calldata _dataUrl, address _organizationAddress) external {
        OrganziationRef storage organziationRef = organizations[_organizationAddress];
        require(bytes(organziationRef.dataUrl).length == 0, 'Address already requested');
        OrganziationRef memory organziationRefTemp = OrganziationRef(_dataUrl, StatusRegistration.PROPOSED);
        organizations[_organizationAddress] = organziationRefTemp;
    }
    
    function approveRequest(address _organizationAddress) external onlyOwnerDao(){
        OrganziationRef storage organziationRef = organizations[_organizationAddress];
        organziationRef.status = StatusRegistration.APPROVED;
    }
    
    function refuseRequest(address _organizationAddress) external onlyOwnerDao(){
        OrganziationRef storage organziationRef = organizations[_organizationAddress];
        organziationRef.status = StatusRegistration.REFUSED;
    }
    
    function revokeAddress() external {
        OrganziationRef storage organziationRef = organizations[msg.sender];
        require(organziationRef.status == StatusRegistration.APPROVED, 'Organization not approved');
        organziationRef.status = StatusRegistration.REVOKED;
    }
    
    function changeAddress(address _newOrganizationAddress) external {
        OrganziationRef storage organziationRef = organizations[msg.sender];
        require(organziationRef.status == StatusRegistration .APPROVED, 'Organization not approved');
        organizations[_newOrganizationAddress] = organziationRef;
        organziationRef.status = StatusRegistration .REVOKED;
    }
    
    
    function hackingBlockAddress(address _newOrganizationAddress) external {
        OrganziationRef storage organziationRefRevoked = organizations[msg.sender];
        OrganziationRef storage organziationRefChanged = organizations[_newOrganizationAddress];
        require(organziationRefRevoked.status == StatusRegistration.REVOKED, 'Organization sender not revoked');
        require(organziationRefChanged.status == StatusRegistration.APPROVED, 'Hacker organization not approved');
        require(keccak256(abi.encodePacked(organziationRefRevoked.dataUrl)) == keccak256(abi.encodePacked(organziationRefChanged.dataUrl)), 'Different identities');
        organziationRefChanged.status = StatusRegistration.BLOCKED;
    }
    
    
}


contract WfcPlatformProposals is WfcPlatformRegistrations {
    
    enum StatusProposal {PROPOSED, REVOKED, REFUSED, APPROVED}
    
    struct FundraisingProposal {
        uint256 line;
        address organization;
        uint256 softcap;
        uint256 hardcap;
        address currency;
        uint256 timeout;
		address destination;
        StatusProposal proposalStatus;
        string metadata;
    }
    
    struct FundraisingApproved {
        address organization;
        uint256 softcap;
        uint256 hardcap;
        uint256 amountDonated;
        uint256 reservePercentage;
        uint256 serviceLinePercentage;
        uint256 allLinesPercentage;
        uint256 teamPercentage;
        address currency;
        uint256 deadline;
		address destination;
        bool isFunded;
        string metadata;
    }
    
    event FundraisingSubmittedLog(uint256 indexed _fundraisingId, uint256 indexed _line, address indexed _organization,  uint256 _softcap, uint256 _hardcap, address _currency, uint256 _timeout, address _destination, string _metadata);
    
    event FundraisingRevokedLog(uint256 indexed _fundraisingId);
    
    event FundraisingRefusedLog(uint256 indexed _fundraisingId);
    
    event FundraisingApprovedLog(uint256 indexed _fundraisingId);
    
    event FundraisingCreatedLog(uint256 indexed _line, uint256 indexed _fundraisingId, address indexed _organization,  uint256 _softcap, uint256 _hardcap, uint256 _reserveSplit, uint256 _serviceLineSplit, uint256 _allLinesSplit, uint256 _teamSplit, address _currency, uint256 _timeout, address _destination, string _metadata);
    
    
    FundraisingProposal[] public proposals;
    
    mapping(uint256 => FundraisingApproved[]) fundraisings;
    
    
    function SubmitFundraising(uint256 _line, uint256 _softcap, uint256 _hardcap, address _tokenAddress, uint256 _timeout, address _destination, string calldata _metadata) external notZeroAddress(_destination) {
        require(organizations[msg.sender].status == StatusRegistration.APPROVED, 'Organization not registred');
        require(serviceLines[_line] == true, 'Wrong service Line');
        require(tokenAddress[_tokenAddress] == true, 'Wrong token');
        uint256 propNumber = proposals.push(FundraisingProposal(_line, msg.sender, _softcap, _hardcap, _tokenAddress, _timeout, _destination, StatusProposal.PROPOSED, _metadata));
        emit FundraisingSubmittedLog(propNumber - 1, _line, msg.sender, _softcap, _hardcap, _tokenAddress, _timeout, _destination, _metadata);
    }
    
    function RevokeFundraising(uint256 _fundraisingId) external {
        FundraisingProposal storage proposal = proposals[_fundraisingId];
        require(msg.sender == proposal.organization, 'Wrong organization' );
        require(proposal.proposalStatus == StatusProposal.PROPOSED, 'Wrong status of proposal');
        proposal.proposalStatus = StatusProposal.REVOKED;
        emit FundraisingRevokedLog(_fundraisingId);
    }
    
    function RefuseFundraising(uint256 _fundraisingId) external onlyOwnerDao() {
        FundraisingProposal storage proposal = proposals[_fundraisingId];
        require(proposal.proposalStatus == StatusProposal.PROPOSED, 'Wrong status of proposal');
        proposal.proposalStatus = StatusProposal.REFUSED;
        emit FundraisingRefusedLog(_fundraisingId);
    }
    
    function ApproveFundraising(uint256 _fundraisingId) external onlyOwnerDao() {
        FundraisingProposal storage proposal = proposals[_fundraisingId];
        require(proposal.proposalStatus == StatusProposal.PROPOSED, 'Wrong status of proposal');
        proposal.proposalStatus = StatusProposal.APPROVED;
        uint256 line = uint256(proposal.line);
        uint256 propNumber = fundraisings[line].push(FundraisingApproved(proposal.organization, proposal.softcap, proposal.hardcap, 0, reserveSplit, serviceLineSplit, allLinesSplit, teamSplit, proposal.currency, now + proposal.timeout, proposal.destination, false, proposal.metadata));
        emit FundraisingCreatedLog(proposal.line, propNumber - 1, proposal.organization, proposal.softcap, proposal.hardcap, reserveSplit, serviceLineSplit, allLinesSplit, teamSplit, proposal.currency, now + proposal.timeout , proposal.destination, proposal.metadata);
    }
}


contract WfcPlatformDonations is WfcPlatformProposals  {
    
    address constant ethAddress = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
    
    struct DonatorSituation {
        uint256 donationAmount;
        bool isWithdrawn;
    }
    
    mapping (uint256 => mapping(uint256 => mapping(address => DonatorSituation ))) public donations;
    
    event Donate(uint256 indexed _line, uint256 indexed _fundraisingId, address indexed _donor, address _currency, uint256 _amount);
    
    function donateEth(uint256 _line, uint256 _fundraisingId) external payable {
        FundraisingApproved storage fundraisingApproved = fundraisings[_line][_fundraisingId];
        require(fundraisingApproved.currency == ethAddress, 'Only eth donation allowed');
        require(now <= fundraisingApproved.deadline, 'fundraising ended');
        require(msg.value % 10000 == 0, 'Last four digits must be zero');
        uint256 donationPercenatge = 10000 - (fundraisingApproved.reservePercentage + fundraisingApproved.serviceLinePercentage + fundraisingApproved.allLinesPercentage + fundraisingApproved.teamPercentage);
        require(fundraisingApproved.hardcap - (fundraisingApproved.amountDonated * donationPercenatge) >= (msg.value * donationPercenatge) , 'Donation too high');
        require(!fundraisingApproved.isFunded, 'Fundraising already funded');
        fundraisingApproved.amountDonated = fundraisingApproved.amountDonated + msg.value;
        DonatorSituation storage donatorSituation = donations[_line][_fundraisingId][msg.sender];
        donatorSituation.donationAmount = donatorSituation.donationAmount + msg.value;
        emit Donate (_line, _fundraisingId, msg.sender, ethAddress, msg.value);
    }
    
    function donateToken(uint256 _line, uint256 _fundraisingId, uint256 _amount) external  {
        FundraisingApproved storage fundraisingApproved = fundraisings[_line][_fundraisingId];
        require(fundraisingApproved.currency != ethAddress, 'Only tokens donation allowed');
        ERC20Token token = ERC20Token(fundraisingApproved.currency);
        require(now <= fundraisingApproved.deadline, 'fundraising ended');
        require(_amount % 10000 == 0, 'Last four digits must be zero');
        uint256 donationPercenatge = 10000 - (fundraisingApproved.reservePercentage + fundraisingApproved.serviceLinePercentage + fundraisingApproved.allLinesPercentage + fundraisingApproved.teamPercentage);
        require(fundraisingApproved.hardcap - (fundraisingApproved.amountDonated * donationPercenatge) >= (_amount * donationPercenatge) , 'Donation too high');
        require(!fundraisingApproved.isFunded, 'Fundraising already funded');
        require(token.transferFrom(msg.sender, address(this), _amount), 'not enough token for donation');
        fundraisingApproved.amountDonated = fundraisingApproved.amountDonated + _amount;
        DonatorSituation storage donatorSituation = donations[_line][_fundraisingId][msg.sender];
        donatorSituation.donationAmount = donatorSituation.donationAmount + _amount;
        emit Donate(_line, _fundraisingId, msg.sender, address(token), _amount);
    }
}
    
contract WfcPlatformLiquidate is WfcPlatformDonations {
    
    uint256  public warrantyTimeout;
    
    function setwarrantyTimeout(uint256 _warrantyTimeout) external onlyOwnerDao {
        warrantyTimeout = _warrantyTimeout;
    }
    
    event DonationWithdrawn(uint256 indexed _line, uint256 indexed _fundraisingId, address indexed _donor, address _currency, uint256 _amount);
    
    event FundraisingFunded(uint256 indexed _line, uint256 indexed _fundraisingId);
    
    constructor(uint256 _warrantyTimeout, Donation _donationContract, Reserve _reserveContract, ServiceLine _serviceLineContract, AllLines _allLinesContract, Team _teamContract, uint256[4] memory _split, uint256 _numberLines, address[] memory _tokensAddress, address _ownerDao) 
        public
        SplitContracts(_donationContract, _reserveContract, _serviceLineContract, _allLinesContract, _teamContract)
        DonationSplit(_split)
        SupportedLines(_numberLines)
        SupportedTokens(_tokensAddress)
        OwnableDao(_ownerDao)
    {
        require(_warrantyTimeout != 0, 'Timeout must be bigger than zero');
        warrantyTimeout = _warrantyTimeout;
    }
        
    function liquidateEthUnfundedFundraising(uint256 _line, uint256 _fundraisingId) external {
        FundraisingApproved storage fundraisingApproved = fundraisings[_line][_fundraisingId];
        DonatorSituation storage donatorSituation = donations[_line][_fundraisingId][msg.sender];
        require(fundraisingApproved.currency == ethAddress, 'Only eth donation allowed');
        require(!fundraisingApproved.isFunded, 'Fundraising already funded');
        require(!donatorSituation.isWithdrawn, 'Donation already withdrawn');
        uint256 donationPercenatge = 10000 - (fundraisingApproved.reservePercentage + fundraisingApproved.serviceLinePercentage + fundraisingApproved.allLinesPercentage + fundraisingApproved.teamPercentage);
        require((now > fundraisingApproved.deadline && (fundraisingApproved.amountDonated * donationPercenatge / 10000) < fundraisingApproved.softcap) || now > fundraisingApproved.deadline + warrantyTimeout, 'fundraising not ended or softcap reached or warranty timeout passed');
        msg.sender.transfer(donatorSituation.donationAmount);
        donatorSituation.isWithdrawn = true;
        emit DonationWithdrawn(_line, _fundraisingId, msg.sender, ethAddress, donatorSituation.donationAmount);
    }
    
    function liquidateTokensUnfundedFundraising(uint256 _line, uint256 _fundraisingId) external {
        FundraisingApproved storage fundraisingApproved = fundraisings[_line][_fundraisingId];
        DonatorSituation storage donatorSituation = donations[_line][_fundraisingId][msg.sender];
        require(fundraisingApproved.currency != ethAddress, 'Only tokens donation allowed');
        require(!fundraisingApproved.isFunded, 'Fundraising already funded');
        require(!donatorSituation.isWithdrawn, 'Donation already withdrawn');
        uint256 donationPercenatge = 10000 - (fundraisingApproved.reservePercentage + fundraisingApproved.serviceLinePercentage + fundraisingApproved.allLinesPercentage + fundraisingApproved.teamPercentage);
        require((now > fundraisingApproved.deadline && (fundraisingApproved.amountDonated * donationPercenatge /10000)  < fundraisingApproved.softcap) || now > fundraisingApproved.deadline + warrantyTimeout, 'fundraising not ended or softcap reached or warranty timeout passed');
        ERC20Token token = ERC20Token(fundraisingApproved.currency);
        require(token.transfer(msg.sender, donatorSituation.donationAmount), 'token transfer failed');
        donatorSituation.isWithdrawn = true;
        emit DonationWithdrawn(_line, _fundraisingId, msg.sender, address(token), donatorSituation.donationAmount);
    }
    
    function startEthFundedFundraising(uint256 _line, uint256 _fundraisingId) external payable {
        FundraisingApproved storage fundraisingApproved = fundraisings[_line][_fundraisingId];
        require(fundraisingApproved.currency == ethAddress, 'Only eth donation allowed');
        require(fundraisingApproved.organization == msg.sender, 'Tx sender different from creator of fundraising');
        uint256 donationPercenatge = 10000 - (fundraisingApproved.reservePercentage + fundraisingApproved.serviceLinePercentage + fundraisingApproved.allLinesPercentage + fundraisingApproved.teamPercentage);
        require(!fundraisingApproved.isFunded, 'Fundraising already funded');
        require(((now > fundraisingApproved.deadline && (fundraisingApproved.amountDonated * donationPercenatge) > fundraisingApproved.softcap) || ((fundraisingApproved.amountDonated * donationPercenatge) == fundraisingApproved.hardcap)) && now < fundraisingApproved.deadline + warrantyTimeout, 'fundraising not yet successfull');
        _EthDonationTransfers(fundraisingApproved.amountDonated, msg.value, donationPercenatge, fundraisingApproved.reservePercentage, fundraisingApproved.serviceLinePercentage, fundraisingApproved.allLinesPercentage, fundraisingApproved.teamPercentage, _line, _fundraisingId);
        fundraisingApproved.isFunded = true;
        emit FundraisingFunded(_line, _fundraisingId);
    }
    
    function startTokensFundedFundraising(uint256 _line, uint256 _fundraisingId, uint256 _warranty) external {
        FundraisingApproved storage fundraisingApproved = fundraisings[_line][_fundraisingId];
        require(fundraisingApproved.currency != ethAddress, 'Only tokens donation allowed');
        require(fundraisingApproved.organization == msg.sender, 'Tx sender different from creator of fundraising');
        uint256 donationPercenatge = 10000 - (fundraisingApproved.reservePercentage + fundraisingApproved.serviceLinePercentage + fundraisingApproved.allLinesPercentage + fundraisingApproved.teamPercentage);
        require(!fundraisingApproved.isFunded, 'Fundraising already funded');
        require(((now > fundraisingApproved.deadline && (fundraisingApproved.amountDonated * donationPercenatge) > fundraisingApproved.softcap) || ((fundraisingApproved.amountDonated * donationPercenatge) == fundraisingApproved.hardcap)) && now > fundraisingApproved.deadline + warrantyTimeout, 'fundraising not yet successfull');
        ERC20Token token = ERC20Token(fundraisingApproved.currency);
        _TokensDonationTransfers(token, msg.sender, fundraisingApproved.amountDonated, _warranty, donationPercenatge, fundraisingApproved.reservePercentage, fundraisingApproved.serviceLinePercentage, fundraisingApproved.allLinesPercentage, fundraisingApproved.teamPercentage, _line, _fundraisingId);
        fundraisingApproved.isFunded = true;
        emit FundraisingFunded(_line, _fundraisingId);
    }
    
    function _EthDonationTransfers(uint256 _amountDonated, uint256 _warranty, uint256 _donationPercenatge, uint256 _reservePercentage, uint256 _serviceLinePercentage, uint256 _allLinesPercentage, uint256 _teamPercentage, uint256 _line, uint256 _fundraisingId) internal{    
        donationContract.transferDonationEth.value((_amountDonated * _donationPercenatge) / 10000)(_line, _fundraisingId);
        donationContract.transferWarrantyEth.value(_warranty)(_line, _fundraisingId);
        reserveContract.transferReserveEth.value((_amountDonated * _reservePercentage) / 10000)(_line, _fundraisingId);
        serviceLineContract.transferServiceLineEth.value((_amountDonated * _serviceLinePercentage) / 10000)(_line, _fundraisingId);
        allLinesContract.transferAllLinesEth.value((_amountDonated * _allLinesPercentage) / 10000)(_line, _fundraisingId);
        teamContract.transferTeamEth.value((_amountDonated * _teamPercentage) / 10000)(_line, _fundraisingId);
    }
    
    function _TokensDonationTransfers(ERC20Token _token, address _sender, uint256 _amountDonated, uint256 _warranty, uint256 _donationPercenatge, uint256 _reservePercentage, uint256 _serviceLinePercentage, uint256 _allLinesPercentage, uint256 _teamPercentage, uint256 _line, uint256 _fundraisingId) internal{    
        require(_token.transfer(address(donationContract), (_amountDonated * _donationPercenatge) / 10000), 'Tokens donation transfer failed');
        donationContract.transferDonationTokens(_line, _fundraisingId, (_amountDonated * _donationPercenatge) / 10000);
        require(_token.transferFrom(_sender, address(donationContract), _warranty), 'Tokens warranty transfer failed');
        donationContract.transferWarrantyTokens(_line, _fundraisingId, _warranty);
        require(_token.transfer(address(reserveContract), (_amountDonated * _reservePercentage) / 10000), 'Tokens reserve transfer failed');
        reserveContract.transferReserveTokens(_line, _fundraisingId, (_amountDonated * _reservePercentage) / 10000);
        require(_token.transfer(address(serviceLineContract), (_amountDonated * _serviceLinePercentage) / 10000), 'Tokens service line transfer failed');
        serviceLineContract.transferServiceLineTokens(_line, _fundraisingId, (_amountDonated * _serviceLinePercentage) / 10000);
        require(_token.transfer(address(allLinesContract), (_amountDonated * _allLinesPercentage) / 10000), 'Tokens all lines transfer failed');
        allLinesContract.transferAllLinesTokens(_line, _fundraisingId, (_amountDonated * _allLinesPercentage) / 10000 );
        require(_token.transfer(address(teamContract), (_amountDonated * _teamPercentage) / 10000), 'Tokens team transfer failed');
        teamContract.transferTeamTokens(_line, _fundraisingId, (_amountDonated * _teamPercentage) / 10000);
    }
}
    

