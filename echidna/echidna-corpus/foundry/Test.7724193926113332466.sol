// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

contract FoundryTest is Test {
    address constant USER1 = address(0x10000);

    // TODO: Replace with your actual contract instance
    CryticERC4626Harness Target;

  function setUp() public {
      // TODO: Initialize your contract here
      Target = new CryticERC4626Harness();
  }

  function test_replay() public {
        _setUpActor(USER1);
        Target.verify_mintProperties(533261916904125120465243920790860, 54);
        _setUpActor(USER1);
        Target.recognizeProfitProxy(2149521088003792927527378551520245725851926962878417533305681369545807684975);
        _setUpActor(USER1);
        Target.verify_convertToAssetsMustNotRevert(54);
  }

  function _setUpActor(address actor) internal {
      vm.startPrank(actor);
      // Add any additional actor setup here if needed
  }

  function _delay(uint256 timeInSeconds, uint256 numBlocks) internal {
      vm.warp(block.timestamp + timeInSeconds);
      vm.roll(block.number + numBlocks);
  }
}
