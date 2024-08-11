class_name WeaponResource
extends Resource

enum FireType {
	semiAuto, # TODO define a "time before can fire again" timer
	fullAuto
}

@export_group("Information")
## The display name of the weapon
@export var weaponName : String = "Unnamed weapon";

@export_group("Visuals")
@export var iconTexture : Texture = null;
@export var wallTexture : Texture = null;

@export_group("Cost")
## How much it would cost to purchase the weapon from the wall
@export var purchaseCost : int = 900;
## How much it costs to purchase full restock of ammo for the weapon
@export var purchaseCostAmmo : int = 450;

@export_group("Firing / Operation")
@export var fireType : FireType = FireType.semiAuto;
## Rounds per minute (firing speed of weapon)
@export var fireRateRPM : float = 600.0;
## Used for shotguns
@export var pelletsPerShot : int = 1;
@export_group("Firing / Ammo")
@export var magazineSize : int = 30;
@export var reloadTimeSeconds : float = 2.0;
## How many magazines of ammo the user should start with (total bullets ammo is this number times magazineSize)
@export var totalMagazineCapacity : int = 10;
@export_group("Firing / Damage")
@export var bulletDamageMinimum : float = 15.0;
@export var bulletDamageMaximum : float = 25.0;
@export_group("Firing / Accuracy")
## How many degrees off of perfect accuracy there is while aiming. Total cone is this number * 2
@export var aimingSpreadAngle : float = 5.0;
## What the above value is multiplied by whenever player is not aiming
@export var nonAimingInaccuracyMultipler : float = 2.0;

@export_group("Miscellaneous")
## Higher number = more likely to roll; 0 = does not show up
@export var mysteryBoxChances : float = 100.0; 
