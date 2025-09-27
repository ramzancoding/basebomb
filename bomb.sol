/**
 *Submitted for verification at basescan.org on 2025-01-16
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RocketGovernmentControl {
    // États de la fusée
    uint public bombCount;
    uint public fuelAmount;
    bool public isNukeEmAllModeOn;
    uint public explodedBombs;

    // Événements pour suivre les actions gouvernementales
    event BombsLoaded(uint count);
    event FuelAdded(uint amount);
    event NukeEmAllModeActivated(bool state);
    event BombsExploded(uint count);

    // Constructeur pour initialiser les paramètres de la fusée
    constructor() {
        bombCount = 0;
        fuelAmount = 0;
        isNukeEmAllModeOn = false;
        explodedBombs = 0;
    }

    // Fonction pour charger un nombre aléatoire de bombes
    function loadBombs() public {
        uint randomBombs = uint(keccak256(abi.encodePacked(block.timestamp, block.prevrandao))) % 101; // Nombre entre 0 et 100
        bombCount += randomBombs;
        emit BombsLoaded(randomBombs);
    }

    // Fonction pour ajouter une quantité aléatoire d'essence
    function addFuel() public {
        uint randomFuel = uint(keccak256(abi.encodePacked(block.timestamp, block.prevrandao))) % 1001; // Quantité entre 0 et 1000
        fuelAmount += randomFuel;
        emit FuelAdded(randomFuel);
    }

    // Fonction pour activer le mode "NukeEmAll"
    function activateNukeEmAllMode() public {
        isNukeEmAllModeOn = true;
        emit NukeEmAllModeActivated(isNukeEmAllModeOn);
    }

    // Fonction pour faire exploser un nombre aléatoire de bombes
    function detonateBombs() public {
        require(isNukeEmAllModeOn, "Le mode NukeEmAll doit etre active pour faire exploser des bombes.");
        require(bombCount > 0, "Aucune bombe disponible a faire exploser.");
        uint randomExplosions = uint(keccak256(abi.encodePacked(block.timestamp, block.prevrandao))) % (bombCount + 1); // Nombre entre 0 et bombCount
        bombCount -= randomExplosions;
        explodedBombs += randomExplosions;
        emit BombsExploded(randomExplosions);
    }

    // Fonction pour obtenir l'état complet de la fusée
    function getRocketStatus() public view returns (string memory) {
        string memory nukeModeStatus = isNukeEmAllModeOn ? "active" : "inactive";
        return string(abi.encodePacked(
            "Bombes chargees: ", uintToString(bombCount), ", Essence: ", uintToString(fuelAmount), ", Mode NukeEmAll: ", nukeModeStatus, ", Bombes explosees: ", uintToString(explodedBombs)
        ));
    }

    // Fonction utilitaire pour convertir un uint en string
    function uintToString(uint v) internal pure returns (string memory) {
        if (v == 0) {
            return "0";
        }
        uint maxLen = 100;
        bytes memory reversed = new bytes(maxLen);
        uint i = 0;
        while (v != 0) {
            uint remainder = v % 10;
            v = v / 10;
            reversed[i++] = bytes1(uint8(48 + remainder));
        }
        bytes memory s = new bytes(i);
        for (uint j = 0; j < i; j++) {
            s[j] = reversed[i - 1 - j];
        }
        return string(s);
    }
}
