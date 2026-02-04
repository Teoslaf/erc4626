// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

// Chimera deps
import {BaseSetup} from "@chimera/BaseSetup.sol";
import {vm} from "@chimera/Hevm.sol";

// Managers
import {ActorManager} from "@recon/ActorManager.sol";
import {AssetManager} from "@recon/AssetManager.sol";

// Helpers
import {Utils} from "@recon/Utils.sol";

// Your deps
import "src/vault.sol";

abstract contract Setup is BaseSetup, ActorManager, AssetManager, Utils {
    ERC4626Mock vaultImpl;
    ERC20Mock token;
    /// === Setup === ///
    function setup() internal virtual override {
        token = new ERC20Mock("Token", "TKN", 18);
        vaultImpl = new ERC4626Mock(token, "Vault Token", "vTKN");
    }

    /// === MODIFIERS === ///
    /// Prank admin and actor
    
    modifier asAdmin {
        vm.prank(address(this));
        _;
    }

    modifier asActor {
        vm.prank(address(_getActor()));
        _;
    }
}
