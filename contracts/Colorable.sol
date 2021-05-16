//SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "hardhat/console.sol";

contract Colorable {
    uint256 dnaDigits = 3;
    uint256 dnaModulus = 10**dnaDigits;
    uint256 randomModifierVariable = 23;

    struct ColorPalette {
        RGB backgroundPrimary;
        RGB backgroundSecondary;
        RGB skinPrimary;
        RGB skinSecondary;
        RGB skinTertiary;
        RGB skinDetailPrimary;
        RGB skinDetailSecondary;
        RGB acessoryPrimary;
        RGB acessorySecondary;
        RGB eyesPrimary;
        RGB eyesSecondary;
        RGB tonguePrimary;
        RGB tongueSecondary;
        RGB teethPrimary;
        RGB teethSecondary;
        RGB consumablePrimary;
        RGB consumableSecondary;
        RGB consumableTertiary;
        RGB consumableLogoPrimary;
        RGB consumableLogoSecondary;
    }

    struct RGB {
        uint256 red;
        uint256 green;
        uint256 blue;
    }

    function generateRGB(uint256 randomNumber, uint256 randomModifier)
        internal
        view
        returns (RGB memory)
    {
        RGB memory rgb;

        uint256 rgbValue = randomNumber % dnaModulus;
        uint256 r = rgbValue / randomModifier;
        uint256 g = (rgbValue / randomModifier) * 2;
        uint256 b = (rgbValue * randomModifier) / (randomModifier / 2);

        rgb = RGB(r <= 255 ? r : 255, g <= 255 ? g : 255, b <= 255 ? b : 255);

        return rgb;
    }

    function createColorPalette(uint256 randomNumber)
        internal
        view
        returns (ColorPalette memory)
    {
        ColorPalette memory colorPalette;
        colorPalette.acessoryPrimary = generateRGB(
            randomNumber,
            randomModifierVariable / 2
        );
        colorPalette.acessorySecondary = generateRGB(
            randomNumber,
            randomModifierVariable + randomModifierVariable / 5
        );
        colorPalette.backgroundPrimary = generateRGB(
            randomNumber,
            randomModifierVariable / 2
        );
        colorPalette.backgroundSecondary = generateRGB(
            randomNumber,
            randomModifierVariable
        );
        colorPalette.consumableLogoPrimary = generateRGB(
            randomNumber,
            randomModifierVariable - (randomModifierVariable / 8)
        );
        colorPalette.consumableLogoSecondary = generateRGB(
            randomNumber,
            randomModifierVariable - (randomModifierVariable / 9)
        );
        colorPalette.consumablePrimary = generateRGB(
            randomNumber,
            randomModifierVariable - (randomModifierVariable / 5)
        );
        colorPalette.consumableSecondary = generateRGB(
            randomNumber,
            randomModifierVariable - (randomModifierVariable / 6)
        );
        colorPalette.consumableTertiary = generateRGB(
            randomNumber,
            randomModifierVariable - (randomModifierVariable / 7)
        );
        colorPalette.eyesPrimary = generateRGB(
            randomNumber,
            randomModifierVariable + randomModifierVariable / 6
        );
        colorPalette.eyesSecondary = generateRGB(
            randomNumber,
            randomModifierVariable + randomModifierVariable / 7
        );
        colorPalette.skinDetailPrimary = generateRGB(
            randomNumber,
            randomModifierVariable + randomModifierVariable / 3
        );
        colorPalette.skinDetailSecondary = generateRGB(
            randomNumber,
            randomModifierVariable + randomModifierVariable / 2
        );
        colorPalette.skinPrimary = generateRGB(
            randomNumber,
            randomModifierVariable / 3
        );
        colorPalette.skinSecondary = generateRGB(
            randomNumber,
            randomModifierVariable * 2
        );
        colorPalette.skinTertiary = generateRGB(
            randomNumber,
            randomModifierVariable * 3
        );
        colorPalette.teethPrimary = generateRGB(
            randomNumber,
            randomModifierVariable - (randomModifierVariable / 3)
        );
        colorPalette.teethSecondary = generateRGB(
            randomNumber,
            randomModifierVariable - (randomModifierVariable / 4)
        );
        colorPalette.tonguePrimary = generateRGB(
            randomNumber,
            randomModifierVariable + randomModifierVariable / 8
        );
        colorPalette.tongueSecondary = generateRGB(
            randomNumber,
            randomModifierVariable - (randomModifierVariable / 2)
        );

        return colorPalette;
    }
}
