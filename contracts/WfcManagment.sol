pragma solidity ^0.5.0;

library StringAsKey {
    function convert(string memory key) internal pure returns (bytes32 ret) {
        require(bytes(key).length < 32, 'String too long');
        assembly {
            ret := mload(add(key, 32))
        }
    }
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
  
  event SetTokenLog(address indexed _tokenAddress, bool _isActivated);
  
  modifier notZeroAddress(address _address) {
      require(_address != address(0), 'zero address not allowed');
      _;
  }
  
  constructor (address[] memory _tokensAddress) internal {
      for (uint i =  0; i < _tokensAddress.length; i++) {
        _setToken(_tokensAddress[i], true);
        emit SetTokenLog(_tokensAddress[i], true);
      }
  }

  function setToken (address _tokenAddress, bool _isActivated) external onlyOwnerDao {
        _setToken(_tokenAddress, _isActivated);
        emit SetTokenLog(_tokenAddress, _isActivated);
  }
  
  function _setToken( address _tokenAddress, bool _isActivated) internal notZeroAddress(_tokenAddress) {
        tokenAddress[_tokenAddress] = _isActivated;
  }

}


contract SupportedLines is OwnableDao  {
    
    using StringAsKey for string;
  
    mapping(bytes32 => bool) private serviceLines;
    
    event SetLineLog(string indexed _line, bool _isActivated);
  
    constructor (string memory _line1, string memory _line2, string memory _line3) internal {
        bytes32  result1 = _line1.convert();
        bytes32  result2 = _line2.convert();
        bytes32  result3 = _line3.convert();
        serviceLines[result1] = true;
        serviceLines[result2] = true;
        serviceLines[result3] = true;
        emit SetLineLog(_line1, true);
        emit SetLineLog(_line2, true);
        emit SetLineLog(_line3, true);
    }

    function setLine(string calldata _line, bool _isActivated) external onlyOwnerDao {
        bytes32  result = _line.convert();
        serviceLines[result] = _isActivated;
        emit SetLineLog(_line, _isActivated);
    }
    
    function getLine(string memory _line) public view returns(bool) {
        bytes32  result = _line.convert();
        return serviceLines[result];
    }

}


contract DonationSplit is OwnableDao {

    uint256 public reserveSplit;
    
    uint256 public serviceLineSplit;
    
    uint256 public allLinesSplit;
    
    uint256 public teamSplit;
    
    event SetReserveSplitLog(uint256 _reserveSplit);
    
    event SetServiceLineSplitLog(uint256 _serviceLineSplit);
    
    event SetAllLinesSplitLog(uint256 _allLinesSplit);
    
    event SetTeamSplitLog(uint256 _teamSplit);
    
    constructor(uint256[4] memory _split) internal {
        reserveSplit = _split[0];    
        serviceLineSplit = _split[1];
        allLinesSplit = _split[2];
        teamSplit = _split[3];
        emit SetReserveSplitLog(_split[0]);
        emit SetServiceLineSplitLog(_split[1]);
        emit SetAllLinesSplitLog(_split[2]);
        emit SetTeamSplitLog(_split[3]);
    }
    
    modifier correctSplit() {
        _;
        require (reserveSplit + serviceLineSplit + allLinesSplit + teamSplit < 10000, 'reserve percent too high');
    }
    
    function setReserveSplit(uint256 _reserveSplit) external onlyOwnerDao correctSplit {
        reserveSplit = _reserveSplit;
        emit SetReserveSplitLog(_reserveSplit);
    }
    
    function setServiceLineSplit(uint256 _serviceLineSplit) external onlyOwnerDao correctSplit {
        serviceLineSplit = _serviceLineSplit;
        emit SetServiceLineSplitLog(_serviceLineSplit);
    }
    
    function setAllLinesSplit(uint256 _allLinesSplit) external onlyOwnerDao correctSplit {
        allLinesSplit = _allLinesSplit;
        emit SetAllLinesSplitLog(_allLinesSplit);
    }
    
    function setTeamSplit(uint256 _teamSplit) external onlyOwnerDao correctSplit {
        teamSplit = _teamSplit;
        emit SetTeamSplitLog(_teamSplit);
    }

}


contract SplitContracts is OwnableDao  {
    
    address public donationContract;
   
    address public reserveContract;
    
    address public serviceLineContract;
   
    address public allLinesContract;
    
    address public teamContract;
	
	address public helpRequest;
	
	event SetdonationContractLog(address _donationContract);
	
	event SetReserveContractLog(address _reserveContract);
	
	event SetServiceLineContractLog(address _serviceLineContract);
	
	event SetAllLinesContractLog(address _allLinesContract);
	
	event SetTeamContractLog(address _teamContract);
	
	event SetHelpRequestLog(address _helpRequest);
	
	modifier notZeroAddress(address _address) {
      require(_address != address(0), 'zero address not allowed');
      _;
    }
    
    constructor(address _donationContract, address _reserveContract, address _serviceLineContract, address _allLinesContract, address _teamContract, address _helpRequest) 
        internal 
        notZeroAddress(_donationContract)
        notZeroAddress(_reserveContract) 
        notZeroAddress(_serviceLineContract)
        notZeroAddress(_allLinesContract)
        notZeroAddress(_teamContract)
		notZeroAddress(_helpRequest)
    {
        donationContract = _donationContract;
        reserveContract = _reserveContract;
        serviceLineContract = _serviceLineContract;
        allLinesContract = _allLinesContract;
        teamContract = _teamContract;
		helpRequest = _helpRequest;
		emit SetdonationContractLog(_donationContract);
		emit SetReserveContractLog(_reserveContract);
		emit SetServiceLineContractLog(_serviceLineContract);
		emit SetAllLinesContractLog(_allLinesContract);
		emit SetTeamContractLog(_teamContract);
		emit SetHelpRequestLog(_helpRequest);
    }
    
    function setDonationContract(address _donationContract) external onlyOwnerDao notZeroAddress(_donationContract) {
        donationContract = _donationContract;
        emit SetdonationContractLog(_donationContract);
    } 
    
    function setReserveContract(address _reserveContract) external onlyOwnerDao notZeroAddress(_reserveContract) {
        reserveContract = _reserveContract;
        emit SetReserveContractLog(_reserveContract);
    } 
    
    function setServiceLineContract(address _serviceLineContract) external onlyOwnerDao notZeroAddress(_serviceLineContract) {
        serviceLineContract = _serviceLineContract;
        emit SetServiceLineContractLog(_serviceLineContract);
    } 
    
    function setAllLinesContract(address _allLinesContract) external onlyOwnerDao notZeroAddress(_allLinesContract) {
        allLinesContract = _allLinesContract;
        emit SetAllLinesContractLog(_allLinesContract);
    } 

    function setTeamContract(address _teamContract) external onlyOwnerDao notZeroAddress(_teamContract) {
        teamContract = _teamContract;
        emit SetTeamContractLog(_teamContract);
    } 
	
	function setHelpRequest(address _helpRequest) external onlyOwnerDao notZeroAddress(_helpRequest) {
	    helpRequest = _helpRequest;
	    emit SetHelpRequestLog(_helpRequest);
	}
}

contract WfcManagment is SupportedTokens, SupportedLines, DonationSplit, SplitContracts{
    
    uint256 public warrantyTimeout;
    
    uint256 public minimalWarrantyPercentage;
    
    event SetWarrantyTimeoutLog(uint256 _warrantyTimeout);
    
    event SetMinimalWarrantyPercentage(uint256 _minimalWarrantyPercentage);
    
    modifier TimeoutBiggerThanZero(uint256 _timeout) {
        require(_timeout > 0, 'Timeout must be bigger than zero');
        _;
    }
    
    constructor(uint256 _warrantyTimeout, uint256 _minimalWarrantyPercentage, address _donationContract, address _reserveContract, address _serviceLineContract, address _allLinesContract, address _teamContract, address _helpRequest,uint256[4] memory _split, string memory _line1, string memory _line2, string memory _line3, address[] memory _tokensAddress, address _ownerDao) 
        public
        SplitContracts(_donationContract, _reserveContract, _serviceLineContract, _allLinesContract, _teamContract, _helpRequest)
        DonationSplit(_split)
        SupportedLines(_line1, _line2, _line3)
        SupportedTokens(_tokensAddress)
        OwnableDao(_ownerDao)
        TimeoutBiggerThanZero(_warrantyTimeout)
    {
        require(_minimalWarrantyPercentage > 0, 'Minimal warranty percentage must be bigger than zero');
        warrantyTimeout = _warrantyTimeout;
        minimalWarrantyPercentage = _minimalWarrantyPercentage;
        emit SetWarrantyTimeoutLog(_warrantyTimeout);
        emit SetMinimalWarrantyPercentage(_minimalWarrantyPercentage);
    }
    
    function setWarrantyTimeout(uint256 _warrantyTimeout) external onlyOwnerDao TimeoutBiggerThanZero(_warrantyTimeout) {
        warrantyTimeout = _warrantyTimeout;
        emit SetWarrantyTimeoutLog(_warrantyTimeout);
    }
    
    function setMinimalWarrantyPercentage(uint256 _minimalWarrantyPercentage) external onlyOwnerDao {
        require(_minimalWarrantyPercentage > 0, 'Minimal warranty percentage must be bigger than zero');
        minimalWarrantyPercentage = _minimalWarrantyPercentage;
        emit SetMinimalWarrantyPercentage(_minimalWarrantyPercentage);
    }
    
}