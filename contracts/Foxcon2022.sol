// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import 'base64-sol/base64.sol';

import './HexStrings.sol';

/* 
  visibility modifiers
  ------------------------------------------------------
  public: anyone can call
  private: only this contract
  internal: only this contract and inheriting contracts
  external: only external calls (not this contract)
*/

contract Foxcon2022 is ERC721, Ownable {
  using Strings for uint256;
  using HexStrings for uint160;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  uint16 _myTotalSupply = 0; // max value 65,535
  uint16 MAX_TICKETS = 8999; // max value 65,535

  constructor() ERC721("Foxcon2022", "FXC22") {
    _tokenIds._value = 999;
  }

  mapping (uint256 => bytes3) public color;
  uint256 mintDeadline = block.timestamp + 24 hours;

  function totalSupply() view public returns(uint256) {
    return _myTotalSupply;
  }

  function mintItem() public payable returns (uint256) {
    /* GA BG: 532775, VIP BG: #76104B */
    require(_myTotalSupply < MAX_TICKETS, 'Purchase would exceed max supply of Tickets');
    require(block.timestamp < mintDeadline, 'DONE MINTING');
    
    _tokenIds.increment();
    uint256 id = _tokenIds.current();
    _mint(msg.sender, id);
    _myTotalSupply++;

    return id;
  }

  function tokenURI(uint256 id) public view override returns (string memory) {
    require(_exists(id), "not exist");
    string memory name = string(abi.encodePacked('Ticket #',id.toString()));
    string memory description = string(abi.encodePacked('This is an NFT fool!'));
    string memory image = Base64.encode(bytes(generateSVGofTokenById(id)));

    return string(
      abi.encodePacked(
        'data:application/json;base64,',
        Base64.encode(
          bytes(
            abi.encodePacked(
              '{"name":"', name, '","description":"', description, '"', 
              '"external_url":"https://metamask.io/foxcon2022', id.toString(), '",', 
              '"attributes": [{"trait_type": "color"}],',
              '"owner":"', (uint160(ownerOf(id))).toHexString(20),'",',
              '"image":"data:image/svg+xml;base64,', image, '"}'
            )
          )
        )
      )
    );
  }

  function generateSVGofTokenById(uint256 id) internal pure returns (string memory) {
    return string(abi.encodePacked(
      '<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg" style="fill-rule:evenodd;clip-rule:evenodd;user-select: none;">',
        renderTokenBottomById(id),
        renderTokenTopById(id),
      '</svg>'
    ));
  }

  function renderTokenTopById(uint256 id) internal pure returns (string memory) {
    return string(abi.encodePacked(
      '<g id="top" transform="matrix(0.99784,0,0,1,2.87767e-18,0)"><path style="fill:#532775;" d="M30,200L20,200C20,188.962 11.038,180 0,180L0,15.368C0,6.886 6.886,0 15.368,0L285.281,0C293.763,0 300.649,6.886 300.649,15.368L300.649,180.033L300,180C288.962,180 280,188.962 280,200L270,200L270,199L264.99,199L264.99,200L260.981,200L260.981,199L255.971,199L255.971,200L251.962,200L251.962,199L246.952,199L246.952,200L242.944,200L242.944,199L237.933,199L237.933,200L233.925,200L233.925,199L228.914,199L228.914,200L224.906,200L224.906,199L219.896,199L219.896,200L215.887,200L215.887,199L210.877,199L210.877,200L206.367,200L206.367,199L201.357,199L201.357,200L197.349,200L197.349,199L192.338,199L192.338,200L188.33,200L188.33,199L183.319,199L183.319,200L179.311,200L179.311,199L174.301,199L174.301,200L170.292,200L170.292,199L165.282,199L165.282,200L161.273,200L161.273,199L156.263,199L156.263,200L152.255,200L152.255,199L147.244,199L147.244,200L143.236,200L143.236,199L138.225,199L138.225,200L134.217,200L134.217,199L129.207,199L129.207,200L125.198,200L125.198,199L120.188,199L120.188,200L116.18,200L116.18,199L111.169,199L111.169,200L107.161,200L107.161,199L102.15,199L102.15,200L98.142,200L98.142,199L93.132,199L93.132,200L89.123,200L89.123,199L84.113,199L84.113,200L80.104,200L80.104,199L75.094,199L75.094,200L71.086,200L71.086,199L66.075,199L66.075,200L62.067,200L62.067,199L57.056,199L57.056,200L53.048,200L53.048,199L48.038,199L48.038,200L44.029,200L44.029,199L39.019,199L39.019,200L35.01,200L35.01,199L30,199L30,200Z" /></g>',
      '<g id="ticketNumber" transform="matrix(0.759459,0,0,0.759459,-97.1428,-1.84609)">',
        '<text x="392px" y="208px" text-align="end" style="font-family:''BalooDa2-ExtraBold'';font-weight:800;font-size:35.368px;fill:rgb(255,146,0);">',
          '#', id.toString(), 
        '</text>',
      '</g>',
      '<g id="dateText" transform="matrix(0.955615,0,0,0.891404,-0.890378,-58.3668)"><text x="24px" y="240px" style="font-family:''BalooDa2-Regular'';font-size:30px;fill:#FFF;">10 DEC / GA</text></g>',
      '<g id="event" transform="matrix(1.06305,0,0,1.06305,-130.636,-63.8082)"><path id="_01F" d="M142.518,87.342L173.881,87.342L173.881,98.119L154.373,98.119L154.373,119.136L169.678,119.136L169.678,129.914L154.373,129.914L154.373,162.786L142.518,162.786L142.518,87.342Z" style="fill:rgb(255,146,0);fill-rule:nonzero;"/><path id="_02O" d="M196.73,163.864C190.91,163.864 186.455,162.212 183.366,158.906C180.276,155.601 178.731,150.931 178.731,144.895L178.731,105.233C178.731,99.197 180.276,94.527 183.366,91.222C186.455,87.916 190.91,86.264 196.73,86.264C202.55,86.264 207.005,87.916 210.095,91.222C213.184,94.527 214.729,99.197 214.729,105.233L214.729,144.895C214.729,150.931 213.184,155.601 210.095,158.906C207.005,162.212 202.55,163.864 196.73,163.864ZM196.73,153.086C200.826,153.086 202.873,150.607 202.873,145.65L202.873,104.478C202.873,99.521 200.826,97.042 196.73,97.042C192.634,97.042 190.587,99.521 190.587,104.478L190.587,145.65C190.587,150.607 192.634,153.086 196.73,153.086Z" style="fill:rgb(255,146,0);fill-rule:nonzero;"/><path id="_03X" d="M231.435,124.202L218.393,87.342L230.896,87.342L238.871,111.7L239.087,111.7L247.278,87.342L258.487,87.342L245.446,124.202L259.134,162.786L246.631,162.786L238.009,136.489L237.794,136.489L228.956,162.786L217.747,162.786L231.435,124.202Z" style="fill:rgb(255,146,0);fill-rule:nonzero;"/><path id="_04C" d="M279.719,163.864C274.043,163.864 269.714,162.248 266.732,159.014C263.75,155.781 262.259,151.218 262.259,145.326L262.259,104.802C262.259,98.91 263.75,94.347 266.732,91.114C269.714,87.88 274.043,86.264 279.719,86.264C285.396,86.264 289.725,87.88 292.707,91.114C295.689,94.347 297.179,98.91 297.179,104.802L297.179,112.777L285.971,112.777L285.971,104.047C285.971,99.377 283.995,97.042 280.043,97.042C276.091,97.042 274.115,99.377 274.115,104.047L274.115,146.189C274.115,150.787 276.091,153.086 280.043,153.086C283.995,153.086 285.971,150.787 285.971,146.189L285.971,134.656L297.179,134.656L297.179,145.326C297.179,151.218 295.689,155.781 292.707,159.014C289.725,162.248 285.396,163.864 279.719,163.864Z" style="fill:rgb(255,146,0);fill-rule:nonzero;"/><path id="_05O" d="M321.645,163.864C315.825,163.864 311.37,162.212 308.281,158.906C305.191,155.601 303.646,150.931 303.646,144.895L303.646,105.233C303.646,99.197 305.191,94.527 308.281,91.222C311.37,87.916 315.825,86.264 321.645,86.264C327.465,86.264 331.92,87.916 335.01,91.222C338.099,94.527 339.644,99.197 339.644,105.233L339.644,144.895C339.644,150.931 338.099,155.601 335.01,158.906C331.92,162.212 327.465,163.864 321.645,163.864ZM321.645,153.086C325.741,153.086 327.789,150.607 327.789,145.65L327.789,104.478C327.789,99.521 325.741,97.042 321.645,97.042C317.55,97.042 315.502,99.521 315.502,104.478L315.502,145.65C315.502,150.607 317.55,153.086 321.645,153.086Z" style="fill:rgb(255,146,0);fill-rule:nonzero;"/><path id="_06N" d="M347.62,87.342L362.493,87.342L374.025,132.501L374.241,132.501L374.241,87.342L384.803,87.342L384.803,162.786L372.624,162.786L358.398,107.712L358.182,107.712L358.182,162.786L347.62,162.786L347.62,87.342Z" style="fill:rgb(255,146,0);fill-rule:nonzero;"/></g>'
    ));
  }

  function renderTokenBottomById(uint256 id) internal pure returns (string memory) {
    return string(abi.encodePacked(
      '<g id="stub1" transform="matrix(1.13574,0,0,1,-32.7365,0.204182)"><path style="fill:#532775;" d="M266.04,199.796L274.826,199.796C274.826,210.834 282.7,219.796 292.398,219.796L292.968,219.763L292.968,284.428C292.968,292.91 286.918,299.796 279.466,299.796L42.326,299.796C34.874,299.796 28.824,292.91 28.824,284.428L28.824,219.796C38.522,219.796 46.395,210.834 46.395,199.796L55.181,199.796L55.181,200.796L59.583,200.796L59.583,199.796L63.105,199.796L63.105,200.796L67.507,200.796L67.507,199.796L71.029,199.796L71.029,200.796L75.431,200.796L75.431,199.796L78.952,199.796L78.952,200.796L83.354,200.796L83.354,199.796L86.876,199.796L86.876,200.796L91.278,200.796L91.278,199.796L94.8,199.796L94.8,200.796L99.202,200.796L99.202,199.796L102.724,199.796L102.724,200.796L107.126,200.796L107.126,199.796L110.647,199.796L110.647,200.796L115.049,200.796L115.049,199.796L118.571,199.796L118.571,200.796L122.973,200.796L122.973,199.796L126.495,199.796L126.495,200.796L130.897,200.796L130.897,199.796L134.418,199.796L134.418,200.796L138.821,200.796L138.821,199.796L142.342,199.796L142.342,200.796L146.744,200.796L146.744,199.796L150.266,199.796L150.266,200.796L154.668,200.796L154.668,199.796L158.19,199.796L158.19,200.796L162.592,200.796L162.592,199.796L166.113,199.796L166.113,200.796L170.515,200.796L170.515,199.796L174.037,199.796L174.037,200.796L178.439,200.796L178.439,199.796L181.961,199.796L181.961,200.796L186.363,200.796L186.363,199.796L189.885,199.796L189.885,200.796L194.287,200.796L194.287,199.796L197.808,199.796L197.808,200.796L202.21,200.796L202.21,199.796L205.732,199.796L205.732,200.796L210.134,200.796L210.134,199.796L214.096,199.796L214.096,200.796L218.498,200.796L218.498,199.796L222.02,199.796L222.02,200.796L226.422,200.796L226.422,199.796L229.943,199.796L229.943,200.796L234.345,200.796L234.345,199.796L237.867,199.796L237.867,200.796L242.269,200.796L242.269,199.796L245.791,199.796L245.791,200.796L250.193,200.796L250.193,199.796L253.714,199.796L253.714,200.796L258.117,200.796L258.117,199.796L261.638,199.796L261.638,200.796L266.04,200.796L266.04,199.796Z" /></g>',
      '<g id="stub2" transform="matrix(0.489601,0,0,0.489601,36.3616,34.5613)">',
        '<text x="78px" y="455px" style="font-family:''BalooDa2-ExtraBold'';font-weight:800;font-size:108px;fill:#FFF;">',
          '#', id.toString(), 
        '</text>',
      '</g>',
      '<g id="stub3" transform="matrix(0.160667,0,0,0.160667,66.1511,212.911)"><text x="62px" y="410px" style="font-family:''BalooDa2-ExtraBold'';font-weight:800;font-size:108px;fill:#FF9200;">General Admission</text></g>'
    ));
  }

}