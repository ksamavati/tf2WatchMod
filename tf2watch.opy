#Global variables

globalvar AmmoSpawnLocations 5
globalvar AmmoSpawnEffects 6
globalvar CurrentIndex 8
globalvar AmmoBoxColor 9


#Player variables

playervar BurnSource 0
playervar Cloaked 1
playervar Ubercharged 2
playervar HealTarget 3
playervar OriginalMaxHealth 4
playervar OverhealMaxPool 5
playervar BeingHealed 7
playervar NumOfDoubleJumps 8
playervar AllowDoubleJump 9
playervar MercyHealOverTimeID 10
playervar OverhealPool 11
playervar HealTargetHealOverTimeID 12
playervar UberchargeEffectArray 13
playervar StickyOrFlaregunEquipped 14
playervar EquippedWeaponHUDText 15
playervar BombDestination 16
playervar BombPosition 17
playervar MovingBombEffect 18
playervar StuckBombsArray 19
playervar Invisible 20
playervar InvisEffectArray 21
playervar InvisTextArray 22
playervar StuckBombLocationsArray 23
playervar ClassGuideHUDTextArray 24
playervar Index 25
playervar Index2 26
playervar PlayersInBlastRadiusArray 27
playervar DistanceFromBlastScalar 28
playervar BuildingEquipped 29
playervar BuildingArray 30
playervar BuildingLocationsArray 31
playervar CurrentBuildSpot 32
playervar DispenserBeamEffect 34
playervar BuildingLevelArray 35
playervar DispenserHealOverTime 36
playervar DispenserText 37
playervar EngineerMetal 39
playervar DispenserCompletion 40
playervar LastConstruction 41
playervar TeleporterCharge 42
playervar SentryCompletion 43
playervar TPEntranceCompletion 44
playervar TPExitCompletion 45
playervar UpgradeProgressArray 46
playervar DispenserMetal 47
playervar SentryText 48
playervar Bot2 49
playervar PlayerTeleported 50
playervar TPEntranceText 51
playervar TPExitText 52
playervar BuildingAttackBeam 53
playervar TimeSinceLastDamage 54
playervar SniperDot 56
playervar BuffBannerActive 57
playervar BuffBannerEffectsArray 58
playervar BuffBannerDamageModID 60
playervar SapperDOTID 61
playervar SniperChargeOnCooldown 62
playervar LastDamageDealt 63
playervar SpyCloakFlicker 65
playervar MetalSpawnTimers 66
playervar BastionDefaultFacing 67
playervar MetalSpawnLocations 68
playervar MetalSpawnEffects 69
playervar FloatingDamageTextbox 70
playervar LastDamageTaken 71
playervar SentryTarget 72
playervar DispenserHP 73
playervar OverhealPoolObject 74
playervar TimeSinceMercyHealed 75
playervar Healer 76
playervar BurningEffect 77
playervar PositionLocationEffects 78
playervar StickyAmmo 79
playervar Bot1 80
playervar TPEntranceHP 81
playervar TPExitHP 82
playervar TPUses 83
playervar PuppetBot 84
playervar PlayerLookingAtSticky 85
playervar StickyBeingLookedAt 86
playervar SentryRocketCooldown 87
playervar AttackStickyBeam 88
playervar BotOwner 89
playervar BuildingSappedArray 90
playervar SapperEffects 91
playervar OngoingSFX 92
playervar BuildingGhostColor 93
playervar TPExitFacing 94
playervar TPColor 95
playervar TorbEquippedWeapon 96
playervar TargetableBySentry 97
playervar BuildingRotation 98
playervar DisguiseSelection 99
playervar Disguised 100
playervar ThirdPersonEnabled 101


#Subroutine names

subroutine InitializeAllSpawns 2
subroutine DestroyDispenser 3
subroutine Decloak 4
subroutine DestroyTPEntrance 5
subroutine DestroyTPExit 6
subroutine InitializeSentry 7
subroutine DestroySentry 8
subroutine InitializeDispenser 9
subroutine InitializeTPEntrance 10
subroutine InitializeTPExit 11
subroutine SwitchToWeapons 12


#Activated extensions

#!extension explosionSounds
#!extension beamSounds
#!extension debuffStatusEffects
#!extension buffAndDebuffSounds


/*
rule "Display server performance characteristics - DEBUG":
    hudHeader(hostPlayer, l"{0}: {1}".format(l"Server Load", l"{0}%".format(getServerLoad())), HudPosition.RIGHT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(hostPlayer, l"{0}: {1}".format(l"Server Load Average", l"{0}%".format(getAverageServerLoad())), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(hostPlayer, l"{0}: {1}".format(l"Server Load Peak", l"{0}%".format(getPeakServerLoad())), HudPosition.RIGHT, 2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
*/

rule "Hero Selection time (4s for DEBUG) -------------------------------INITIALIZATION-----------------------------":
    @Condition isAssemblingHeroes() == true
    
    setMatchTime(4)


rule "Setup Time (5s for DEBUG/60s normal)":
    @Condition isInSetup() == true
    
    #setMatchTime(60)
    setMatchTime(5)


rule "Round timer (1h for DEBUG, default normal)":
    @Condition isGameInProgress() == true
    
    setMatchTime(3599)


rule "Third Person Camera (DEBUG)":
    @Event eachPlayer
    
    eventPlayer.startCamera(eventPlayer.getEyePosition() + worldVector(vect(1, 0, -1.5), eventPlayer, Transform.ROTATION), raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 1000, getAllPlayers(), eventPlayer, true).getHitPosition(), 22)


rule "Press F to spawn Enemy Dummy Bot (DEBUG)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    #Specific Hero
    #createDummy(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam()), -1, raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 10, getAllPlayers(), eventPlayer, true).getHitPosition(), eventPlayer.getFacingDirection() * vect(-1, -1, -1))
    #Random Hero
    createDummy(random.choice(eventPlayer.getAllowedHeroes()), getOppositeTeam(eventPlayer.getTeam()), -1, raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 10, getAllPlayers(), eventPlayer, true).getHitPosition(), eventPlayer.getFacingDirection() * vect(-1, -1, -1))
    eventPlayer.PuppetBot = getLastCreatedEntity()
    #Create red circles at Position and Eye Position
    #createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, getPlayers(getOppositeTeam(eventPlayer.getTeam())).last(), 0.5, EffectReeval.POSITION_AND_RADIUS)
    #eventPlayer.PositionLocationEffects.append(getLastCreatedEntity())
    #createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, getPlayers(getOppositeTeam(eventPlayer.getTeam())).last().getEyePosition(), 0.5, EffectReeval.POSITION_AND_RADIUS)
    #eventPlayer.PositionLocationEffects.append(getLastCreatedEntity())


rule "Bot presses E when player presses E":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    
    eventPlayer.PuppetBot.startForcingButton(Button.ABILITY_2)
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_2), 99999)
    eventPlayer.PuppetBot.stopForcingButton(Button.ABILITY_2)


rule "Bot presses Shift when player presses Shift":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    eventPlayer.PuppetBot.startForcingButton(Button.ABILITY_1)
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_1), 99999)
    eventPlayer.PuppetBot.stopForcingButton(Button.ABILITY_1)


rule "Bot fires when player fires (DEBUG)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    eventPlayer.PuppetBot.startForcingButton(Button.PRIMARY_FIRE)
    waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), 99999)
    eventPlayer.PuppetBot.stopForcingButton(Button.PRIMARY_FIRE)


/*
rule "Bot altfires when player altfires (DEBUG)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    eventPlayer.getPlayerClosestToReticle(Team.ALL).forceButtonPress(Button.SECONDARY_FIRE)
*/

/*
rule "Bot ults when player ults (DEBUG)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    
    eventPlayer.PuppetBot.startForcingButton(Button.ULTIMATE)
    waitUntil(not eventPlayer.isHoldingButton(Button.ULTIMATE), 99999)
    eventPlayer.PuppetBot.stopForcingButton(Button.ULTIMATE)
*/

/*
rule "Press E for SOUND TEST (DEBUG)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    
    playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    A = getPayloadProgressPercentage()
*/

rule "Remove bot on death (DEBUG)":
    @Event playerDied
    @Condition eventPlayer.isDummy() == true
    
    wait(5)
    destroyDummy(eventPlayer.getTeam(), eventPlayer.getSlot())


rule "Voiceline to spawn friendly bot (DEBUG)":
    @Event eachPlayer
    @Condition eventPlayer.isCommunicatingVoiceline() == true
    
    createDummy(Hero.MERCY, eventPlayer.getTeam(), -1, raycast(eventPlayer.getEyePosition(), eventPlayer.getFacingDirection() * 1000, getAllPlayers(), eventPlayer, true).getHitPosition(), vect(-1 * eventPlayer.getFacingDirection().x, 0, -1 * eventPlayer.getFacingDirection().z))


rule "Press Voice Line to make bot fire - DEBUG":
    @Event eachPlayer
    #Voice line pressed
    @Condition eventPlayer.isCommunicatingVoiceline() == true
    #Player closest to reticule is bot
    @Condition eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())).isDummy() == true
    
    #eventPlayer.getPlayerClosestToReticle(Team.ALL).forceButtonPress(Button.SECONDARY_FIRE)
    #Toggle hold LMB (using NumOfDoubleJumps as a flag for toggle)
    if not eventPlayer.NumOfDoubleJumps:
        eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())).startForcingButton(Button.PRIMARY_FIRE)
        eventPlayer.NumOfDoubleJumps = true
    else:
        eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())).stopForcingButton(Button.PRIMARY_FIRE)
        eventPlayer.NumOfDoubleJumps = false


/*
rule "Press shift to deal 299 damage to bot - DEBUG":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    damage(getPlayersOnHero(Hero.DVA, Team.ALL), null, 299)
*/

/*
rule "Press Shift to deal 124 damage to self - DEBUG":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    damage(eventPlayer, null, 124)
*/

rule "Initialize Player (One-time inititalization)":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    
    chase(eventPlayer.TimeSinceLastDamage, 10, rate=1, ChaseReeval.NONE)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.setMaxHealth(1)


def InitializeAllSpawns():
    @Name "Initialize All Hero Swaps (subroutine) (Runs every time player spawns as any hero)"
    
    eventPlayer.removeAllHealthPools()
    #Reset all default settings
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setUltEnabled(false)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.stopAllHoT()
    eventPlayer.stopAllDoT()
    #Set default player variables
    eventPlayer.TimeSinceLastDamage = 10
    eventPlayer.OverhealPool = 0
    eventPlayer.OriginalMaxHealth = eventPlayer.getMaxHealth()
    eventPlayer.OverhealMaxPool = eventPlayer.getMaxHealth() * 0.5
    #Clear Existing HUD text
    for eventPlayer.Index in range(len(eventPlayer.ClassGuideHUDTextArray)):
        destroyHudText(eventPlayer.ClassGuideHUDTextArray[eventPlayer.Index])
    destroyHudText(eventPlayer.EquippedWeaponHUDText[0])
    destroyHudText(eventPlayer.EquippedWeaponHUDText[1])
    eventPlayer.ClassGuideHUDTextArray = null
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.BeingHealed = false
    eventPlayer.setHealingDealt(100)
    eventPlayer.setReloadEnabled(true)
    if eventPlayer.getCurrentHero() != Hero.TORBJORN:
        #Clear any ghost effects
        destroyEffect(eventPlayer.BuildingArray[0])
        destroyEffect(eventPlayer.BuildingArray[5])
    if eventPlayer.getCurrentHero() != Hero.TORBJORN and eventPlayer.BuildingLocationsArray != null:
        DestroySentry()
        DestroyDispenser()
        DestroyTPEntrance()
        DestroyTPExit()
    eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.OverhealPool, true, true)
    eventPlayer.OverhealPoolObject = getLastCreatedHealthPool()
    eventPlayer.setMaxHealth(0)
    eventPlayer.setProjectileGravity(100)
    eventPlayer.TargetableBySentry = true
    eventPlayer.setMoveSpeed(100)


rule "Reset TimeSinceLastDamage on damage":
    @Event playerTookDamage
    
    eventPlayer.TimeSinceLastDamage = 0


rule "Initialize Soldier (Pharah)":
    @Event eachPlayer
    @Hero pharah
    
    InitializeAllSpawns()
    eventPlayer.setUltEnabled(true)
    eventPlayer.setDamageDealt(83.333)
    #Big Text / Medium Text
    hudText(eventPlayer, "Soldier", null, "", HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    #Medium Text
    hudSubtext(eventPlayer, "Aim a rocket at your feet and jump to perform a rocket jump", HudPosition.LEFT, 2, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    #Small Text
    hudSubtext(eventPlayer, "Damage enemies to charge your Buff Banner, Q to activate", HudPosition.LEFT, 3, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    #Small Text
    hudSubtext(eventPlayer, "While active, you and your allies will deal minicrits for 10 seconds", HudPosition.LEFT, 4, Color.WHITE, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudHeader(eventPlayer, null, HudPosition.LEFT, 5, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    eventPlayer.setReloadEnabled(false)
    eventPlayer.addHealthPool(Health.NORMAL, 197, true, false)
    eventPlayer.OverhealMaxPool = 101


rule "Initialize Pyro (Mei)":
    @Event eachPlayer
    @Hero mei
    
    InitializeAllSpawns()
    eventPlayer.setProjectileSpeed(75)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    eventPlayer.setDamageDealt(150)
    eventPlayer.EquippedWeaponHUDText = "Flamethrower"
    hudText(eventPlayer, eventPlayer.EquippedWeaponHUDText, null, "(E) >", HudPosition.TOP, 1, Color.RED, Color.WHITE, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, "Pyro", "", "", HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, null, "", "Attacks burn enemies over time", HudPosition.LEFT, 2, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudSubtext(eventPlayer, "RMB to airblast enemies away and extinguish teammates", HudPosition.LEFT, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, null, "", "E to switch to Flare Gun", HudPosition.LEFT, 4, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, null, "", "Flare Gun will crit against burning enemies.", HudPosition.LEFT, 5, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudHeader(eventPlayer, null, HudPosition.LEFT, 10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.addHealthPool(Health.NORMAL, 172, true, false)
    eventPlayer.OverhealMaxPool = 88.5
    eventPlayer.setSecondaryFireEnabled(false)


rule "Initialize Scout (Reaper) - Set Number of doublejumps to 1/No passive self-heal":
    @Event eachPlayer
    @Hero reaper
    
    InitializeAllSpawns()
    #Disable passive heal
    eventPlayer.setHealingDealt(0)
    eventPlayer.NumOfDoubleJumps = 1
    #Clear Existing HUD text
    for eventPlayer.Index in range(len(eventPlayer.ClassGuideHUDTextArray)):
        destroyHudText(eventPlayer.ClassGuideHUDTextArray[eventPlayer.Index])
    eventPlayer.ClassGuideHUDTextArray = null
    hudText(eventPlayer, "Scout", "", "", HudPosition.LEFT, 0, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, "", null, "Go fast", HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudSubtext(eventPlayer, "Double-jump", HudPosition.LEFT, 2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudSubtext(eventPlayer, "Shotgun auto-reloads, one shell at a time", HudPosition.LEFT, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    eventPlayer.setProjectileSpeed(100)
    hudSubtext(eventPlayer, "Capture speed doubled", HudPosition.LEFT, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setUltEnabled(false)
    eventPlayer.OriginalMaxHealth = eventPlayer.getMaxHealth()
    eventPlayer.OverhealMaxPool = eventPlayer.getMaxHealth() * 1.5
    eventPlayer.setReloadEnabled(false)
    eventPlayer.addHealthPool(Health.NORMAL, 122, true, false)
    eventPlayer.OverhealMaxPool = 63.5
    if eventPlayer.isDummy():
        eventPlayer.setMoveSpeed(76.571)


rule "Initialize Heavy (D.Va)":
    @Event eachPlayer
    @Hero dva
    
    InitializeAllSpawns()
    #Disable Barrier
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setUltEnabled(true)
    hudText(eventPlayer, "Heavy", "", "", HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, "", null, "Hold right mouse to spin up your minigun", HudPosition.LEFT, 2, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, "", null, "Press Q to eat your sandvich for full HP recovery", HudPosition.LEFT, 3, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, "", null, "You have the highest health and firepower of any class", HudPosition.LEFT, 4, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, "", null, "but you are also the slowest and your minigun takes time to spin up", HudPosition.LEFT, 5, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudHeader(eventPlayer, null, HudPosition.LEFT, 10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    eventPlayer.addHealthPool(Health.NORMAL, 293, true, false)
    eventPlayer.OverhealMaxPool = 151
    eventPlayer.setPrimaryFireEnabled(false)


rule "Initialize Demoman (Junkrat)":
    @Event eachPlayer
    @Hero junkrat
    
    InitializeAllSpawns()
    eventPlayer.OriginalMaxHealth = eventPlayer.getMaxHealth()
    eventPlayer.OverhealMaxPool = eventPlayer.getMaxHealth() * 1.5
    hudText(eventPlayer, "PIPEBOMB LAUNCHER", null, "(E) Switch", HudPosition.TOP, 1, Color.BLUE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray[0] = getLastCreatedText()
    hudText(eventPlayer, "{0} / 8".format(eventPlayer.StickyAmmo), "Sticky Ammo", null, HudPosition.RIGHT, 2, Color.BLUE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    eventPlayer.StickyOrFlaregunEquipped = false
    eventPlayer.BombDestination = 1
    eventPlayer.setDamageDealt(83.4)
    hudText(eventPlayer, "Demoman", "", "", HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, "", null, "E to toggle Stickybomb Launcher", HudPosition.LEFT, 2, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, "", null, "Right-click to detonate stickybombs", HudPosition.LEFT, 3, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, "", null, "Sticky-jump by detonating stickybomb beneath you", HudPosition.LEFT, 4, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudHeader(eventPlayer, null, HudPosition.LEFT, 10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    eventPlayer.setReloadEnabled(false)
    eventPlayer.addHealthPool(Health.NORMAL, 172, true, false)
    eventPlayer.OverhealMaxPool = 89
    eventPlayer.StickyAmmo = 8


rule "Initialize Engineer (Torbjorn)":
    @Event eachPlayer
    @Hero torbjorn
    
    #Prevent another player from selecting torb
    #getPlayers(eventPlayer.getTeam()).exclude(eventPlayer).setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(Hero.TORBJORN))
    InitializeAllSpawns()
    eventPlayer.setProjectileGravity(0)
    eventPlayer.EngineerMetal = 200
    #DEBUG: Metal regen
    chase(eventPlayer.EngineerMetal, 200, rate=3, ChaseReeval.NONE)
    eventPlayer.BuildingEquipped = "None"
    hudText(eventPlayer, eventPlayer.BuildingEquipped, null, "(E) >", HudPosition.TOP, 1, Color.ORANGE, Color.WHITE, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT)
    eventPlayer.EquippedWeaponHUDText = getLastCreatedText()
    hudHeader(eventPlayer, "Metal: {0}".format(ceil(eventPlayer.EngineerMetal)), HudPosition.TOP, 2, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.EquippedWeaponHUDText[1] = getLastCreatedText()
    eventPlayer.setDamageDealt(82)
    #eventPlayer.BuildingEquipped = 0
    eventPlayer.CurrentBuildSpot = raycast(eventPlayer.getEyePosition(), vect((eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2).x, eventPlayer.getPosition().y + 0.35, (eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2).z), getAllPlayers(), getAllPlayers(), false).getHitPosition()
    #Class Guide HUD Text
    hudText(eventPlayer, "Engineer", "", "", HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, "", null, "Press Q and E to cycle through buildable items", HudPosition.LEFT, 2, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudSubtext(eventPlayer, "Left-click to build (if you have enough metal)", HudPosition.LEFT, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudSubtext(eventPlayer, "Press Shift to quickly switch back to your weapons", HudPosition.LEFT, 4, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudSubtext(eventPlayer, "Your sentry deals devastating damage in a limited range (Range displayed in red when placing)", HudPosition.LEFT, 5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudSubtext(eventPlayer, "Your dispenser heals nearby allies and generates metal to build with", HudPosition.LEFT, 6, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudSubtext(eventPlayer, "Your buildings can be healed and upgraded by hitting them with your wrench (costs metal)", HudPosition.LEFT, 7, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudHeader(eventPlayer, null, HudPosition.LEFT, 10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    eventPlayer.setMaxHealth(1)
    eventPlayer.addHealthPool(Health.NORMAL, 122, true, false)
    eventPlayer.OverhealMaxPool = 63.5
    eventPlayer.BuildingLevelArray[3] = 1
    eventPlayer.Bot1 = null
    eventPlayer.BuildingGhostColor = Color.RED
    eventPlayer.BuildingRotation = iconString(Icon.ARROW_UP)


rule "Initialize Medic (Mercy) - Start healing over time":
    @Event eachPlayer
    @Hero mercy
    
    InitializeAllSpawns()
    eventPlayer.setHealingDealt(88)
    #Enable Ultimate
    eventPlayer.setUltEnabled(true)
    eventPlayer.setSecondaryFireEnabled(false)
    hudText(eventPlayer, "MEDIC", "", "", HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, "", null, "Heal your allies to build up your Übercharge", HudPosition.LEFT, 2, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, "", null, "You can heal your allies up to 150% of their max HP", HudPosition.LEFT, 3, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, "", null, "Press Q to unleash your Übercharge,", HudPosition.LEFT, 4, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, "", null, "making you and your heal target invulnerable for 8 seconds", HudPosition.LEFT, 5, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudHeader(eventPlayer, null, HudPosition.LEFT, 10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    eventPlayer.addHealthPool(Health.NORMAL, 147, true, false)
    eventPlayer.OverhealMaxPool = 76
    eventPlayer.setUltCharge(0)


rule "Initialize Sniper (Widowmaker)":
    @Event eachPlayer
    @Hero widowmaker
    
    InitializeAllSpawns()
    #Ult guages sniper charge
    eventPlayer.setUltEnabled(true)
    eventPlayer.setDamageDealt(55)
    eventPlayer.OriginalMaxHealth = eventPlayer.getMaxHealth()
    eventPlayer.OverhealMaxPool = eventPlayer.getMaxHealth() * 1.5
    hudText(eventPlayer, "Sniper", null, "", HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, "", null, "Your ult guage displays your sniper's charge", HudPosition.LEFT, 2, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, "", null, "Your sniper charges more slowly than Widowmaker's", HudPosition.LEFT, 3, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, "", null, "Enemies can see a small dot at your crosshair's location", HudPosition.LEFT, 4, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, "", null, "A fully-charged bodyshot will instantly kill weaker classes", HudPosition.LEFT, 5, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudHeader(eventPlayer, null, HudPosition.LEFT, 10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    eventPlayer.addHealthPool(Health.NORMAL, 122, true, false)
    eventPlayer.OverhealMaxPool = 64


rule "Initialize Spy (Cassidy)":
    @Event eachPlayer
    @Hero mccree
    
    InitializeAllSpawns()
    eventPlayer.OriginalMaxHealth = eventPlayer.getMaxHealth()
    eventPlayer.OverhealMaxPool = eventPlayer.getMaxHealth() * 1.5
    eventPlayer.setUltEnabled(true)
    eventPlayer.setUltCharge(100)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.setSecondaryFireEnabled(false)
    #Spy Revolver damage scalar = 0.57, Ambassador = 48.45
    eventPlayer.setDamageDealt(48.45)
    hudText(eventPlayer, "Spy", null, "", HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudText(eventPlayer, "", null, "Press Right Mouse Button (or Q) to toggle invisiblity.", HudPosition.LEFT, 2, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudSubtext(eventPlayer, "Backstab your foes from behind (melee attack) for an instant kill!", HudPosition.LEFT, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudSubtext(eventPlayer, "Melee an enemy turret to use your Electro-Sapper and disable it", HudPosition.LEFT, 4, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    hudSubtext(eventPlayer, "Moving onto the objective will disable your cloak", HudPosition.LEFT, 5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    eventPlayer.addHealthPool(Health.NORMAL, 122, true, false)
    eventPlayer.OverhealMaxPool = 63.5
    eventPlayer.TimeSinceLastDamage = 60
    eventPlayer.TargetableBySentry = false
    eventPlayer.setMoveSpeed(107)
    eventPlayer.DisguiseSelection = Hero.REAPER
    hudText(eventPlayer, heroIcon(eventPlayer.DisguiseSelection), "Disguise (Shift)", "(E) >", HudPosition.TOP, 1, Color.WHITE, Color.WHITE, Color.YELLOW, HudReeval.STRING, SpecVisibility.DEFAULT)
    eventPlayer.ClassGuideHUDTextArray.append(getLastCreatedText())
    eventPlayer.ThirdPersonEnabled = true


rule "Floating Damage Numbers / Sniper damage calculation":
    @Event playerDealtDamage
    
    if eventPlayer.getCurrentHero() == Hero.WIDOWMAKER and eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        if eventWasCriticalHit:
            eventPlayer.LastDamageDealt = round(150 + 3 * eventPlayer.getUltCharge())
            damage(victim, eventPlayer, eventPlayer.LastDamageDealt * 100)
        else:
            eventPlayer.LastDamageDealt = round(50 + eventPlayer.getUltCharge())
            damage(victim, eventPlayer, eventPlayer.LastDamageDealt * 100)
        createInWorldText(eventPlayer, "-{0}".format(eventPlayer.LastDamageDealt), victim, 1, Clip.NONE, WorldTextReeval.STRING, Color.YELLOW, SpecVisibility.DEFAULT)
        eventPlayer.FloatingDamageTextbox = getLastCreatedText()
    else:
        eventPlayer.LastDamageTaken = eventDamage
        createInWorldText(eventPlayer, "-{0}".format(round(eventPlayer.LastDamageTaken)), victim, 1, Clip.NONE, WorldTextReeval.STRING, Color.YELLOW, SpecVisibility.DEFAULT)
        eventPlayer.FloatingDamageTextbox = getLastCreatedText()
    wait(0.45)
    destroyInWorldText(eventPlayer.FloatingDamageTextbox)


rule "Die instead of De-meching-------------------------------------------Heavy /DVa -----------------------------------":
    @Event eachPlayer
    @Hero dva
    @Condition (eventPlayer.getMaxHealth() > 294 and eventPlayer.getMaxHealth() < 297) == true
    
    kill(eventPlayer, null)


rule "Press Q to sandvich":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isInSpawnRoom() == false
    
    #createEffect(getAllPlayers(), Effect.MERCY_HEAL_BEAM_SOUND, Color.WHITE, eventPlayer, 100, EffectReeval.NONE)
    #eventPlayer.OngoingSFX = getLastCreatedEntity()
    bigMessage(eventPlayer, "Eating Sandvich")
    #Reset ult guage
    eventPlayer.setUltCharge(0)
    #Switch to 3rd person camera
    eventPlayer.startCamera(eventPlayer.getEyePosition() + worldVector(vect(0, 0, 2), eventPlayer, Transform.ROTATION), eventPlayer.getEyePosition(), 1000)
    eventPlayer.setStatusEffect(null, Status.STUNNED, 4.3)
    wait(1)
    #Heal for (188 x 0.4 = 75hp)
    heal(eventPlayer, eventPlayer, 75)
    playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    wait(1)
    eventPlayer.clearStatusEffect(Status.BURNING)
    heal(eventPlayer, eventPlayer, 75)
    playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    wait(1)
    heal(eventPlayer, eventPlayer, 75)
    playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    wait(1)
    heal(eventPlayer, eventPlayer, 75)
    playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    wait(0.3)
    eventPlayer.stopCamera()


rule "Charge sandvich in spawn room":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInSpawnRoom() == true
    
    eventPlayer.setUltCharge(100)


rule "Minigun spinup":
    @Event eachPlayer
    @Hero dva
    @Condition (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)) == true
    
    #eventPlayer.setMoveSpeed(47)
    wait(0.87, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setPrimaryFireEnabled(true)
    #eventPlayer.setStatusEffect(null, Status.FROZEN, 0.87)
    eventPlayer.setDamageDealt(100)
    eventPlayer.disallowButton(Button.JUMP)


rule "Minigun spindown":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false
    
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setDamageDealt(0)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.setPrimaryFireEnabled(false)


rule "Movespeed for LMB held":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.isFiringPrimaryFire() == true
    
    eventPlayer.setMoveSpeed(75)


rule "Movespeed for LMB held (not firing)":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.isFiringPrimaryFire() == false
    
    eventPlayer.setMoveSpeed(46)


rule "Movespeed for RMB held":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false
    
    eventPlayer.setMoveSpeed(46)


rule "Delay between sniper shots ----------------------------- Sniper / Widowmaker --------------------------------------":
    @Event eachPlayer
    @Hero widowmaker
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isFiringPrimaryFire() == true
    
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.SniperChargeOnCooldown = true
    eventPlayer.setUltCharge(0)
    #Refund the ammo
    eventPlayer.setAmmo(0, eventPlayer.getAmmo(0) + 5)
    wait(1)
    eventPlayer.setUltCharge(0)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.SniperChargeOnCooldown = false


rule "Paint crosshair dot & Charge Sniper":
    @Event eachPlayer
    @Hero widowmaker
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.SniperChargeOnCooldown != true
    @Condition eventPlayer.isOnGround() == true
    
    wait(0.33, Wait.ABORT_WHEN_FALSE)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, updateEveryTick(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * vect(1000, 1000, 1000), [player for player in getAllPlayers() if not player.Invisible], eventPlayer, true).getHitPosition()), 0.5 * 0.001 * eventPlayer.getUltCharge(), EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.SniperDot = getLastCreatedEntity()
    while eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and eventPlayer.isOnGround() and not eventPlayer.SniperChargeOnCooldown:
        eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 5)
        wait(0.165)
    destroyEffect(eventPlayer.SniperDot)
    eventPlayer.setUltCharge(0)


rule "Sniper (Widowmaker) - SMG Damage":
    @Event eachPlayer
    @Hero widowmaker
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false
    #@Condition eventPlayer.isFiringPrimaryFire() == true
    
    eventPlayer.setDamageDealt(55)


rule "Sniper (Widowmaker) - Sniper Damage":
    @Event eachPlayer
    @Hero widowmaker
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    eventPlayer.setDamageDealt(1)


rule "All damage burns for 10s / Flare Gun Crit ----------------------- Pyro / Mei -------------------------------------":
    @Event playerDealtDamage
    @Hero mei
    #Doesn't work against Mei (Pyro)
    @Condition victim.getCurrentHero() != Hero.MEI
    #Doesn't work on Engineer turrets
    @Condition victim.getCurrentHero() != Hero.BASTION
    #Damage source must be primary or alt fire
    @Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.SECONDARY_FIRE) == true
    
    #If weapon is flare gun (30 dmg) and target is burning
    if eventAbility == Button.SECONDARY_FIRE and victim.hasStatusEffect(Status.BURNING):
        #Deal 60 bonus damage (150 * 0.4)
        damage(victim, eventPlayer, 150)
        eventPlayer.LastDamageTaken = 90
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 1)
    #Set Burning for 10s
    victim.setStatusEffect(eventPlayer, Status.BURNING, 10)
    if victim.BurningEffect == null:
        createEffect(getAllPlayers(), Effect.ASHE_DYNAMITE_BURNING_PARTICLE, Color.WHITE, victim, 1, EffectReeval.POSITION_AND_RADIUS)
        victim.BurningEffect = getLastCreatedEntity()
    victim.BurnSource = eventPlayer
    if victim.Cloaked:
        victim.forceButtonPress(Button.SECONDARY_FIRE)


rule "E to switch weapons Flamethrower/Flare Gun":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    
    if eventPlayer.StickyOrFlaregunEquipped:
        eventPlayer.EquippedWeaponHUDText = "Flamethrower"
        eventPlayer.StickyOrFlaregunEquipped = false
        eventPlayer.setPrimaryFireEnabled(true)
        eventPlayer.setProjectileSpeed(75)
        eventPlayer.setDamageDealt(150)
    else:
        eventPlayer.EquippedWeaponHUDText = "Flare Gun"
        eventPlayer.StickyOrFlaregunEquipped = true
        eventPlayer.setPrimaryFireEnabled(false)
        eventPlayer.setProjectileSpeed(50)
        eventPlayer.setDamageDealt(40)


rule "Fire Flare Gun":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.StickyOrFlaregunEquipped == true
    @Condition (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)) == true
    
    eventPlayer.setSecondaryFireEnabled(true)
    #wait()
    eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
    wait(0.4)
    eventPlayer.setSecondaryFireEnabled(false)
    wait(1.6)
    if RULE_CONDITION:
        goto RULE_START


rule "Burning players take 8dps for 10s":
    @Event eachPlayer
    @Condition eventPlayer.hasStatusEffect(Status.BURNING) == true
    
    wait(0.5)
    if eventPlayer.BurnSource.StickyOrFlaregunEquipped:
        damage(eventPlayer, eventPlayer.BurnSource, 10)
    else:
        damage(eventPlayer, eventPlayer.BurnSource, 2.667)
    if RULE_CONDITION:
        goto RULE_START


rule "Airblast (RMB)":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.StickyOrFlaregunEquipped == false
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    if distance(eventPlayer, eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam()))) <= 4:
        eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())).applyImpulse(vect(0, 1, 0), 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())).applyImpulse(eventPlayer.getFacingDirection(), 25, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    if distance(eventPlayer, eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam())) <= 4:
        eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam()).clearStatusEffect(Status.BURNING)
    eventPlayer.setUltCharge(0)
    playEffect(eventPlayer, DynamicEffect.BAD_EXPLOSION, Color.WHITE, eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() + vect(0, -0.4, 0), 1)
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 1)
    #Give kill credit to Mei if target dies to environment
    eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())).setEnvironmentalKillCreditor(eventPlayer)


rule "Pick up healthpack = Clear burn":
    @Event playerReceivedHealing
    @Condition eventWasHealthPack == true
    @Condition eventPlayer.hasStatusEffect(Status.BURNING) == true
    
    eventPlayer.clearStatusEffect(Status.BURNING)
    eventPlayer.BurnSource = null


rule "BeingHealed by medic for 1s = Clear burn":
    @Event eachPlayer
    @Condition eventPlayer.BeingHealed == true
    @Condition eventPlayer.hasStatusEffect(Status.BURNING) == true
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.clearStatusEffect(Status.BURNING)
    eventPlayer.BurnSource = null


rule "Enter spawnroom = Clear burn":
    @Event eachPlayer
    @Condition eventPlayer.isInSpawnRoom() == true
    
    eventPlayer.clearStatusEffect(Status.BURNING)


rule "If burning stops, destroy Ashe burn effect":
    @Event eachPlayer
    @Condition eventPlayer.hasStatusEffect(Status.BURNING) == false
    
    destroyEffect(eventPlayer.BurningEffect)
    eventPlayer.BurningEffect = null


rule "Backstab damage bonus----------------------------------------- Spy / McCree ----------------------------------------":
    @Event playerDealtDamage
    @Hero mccree
    @Condition eventPlayer.Invisible == false
    @Condition eventAbility == Button.MELEE
    @Condition victim.getCurrentHero() != Hero.BASTION
    @Condition victim.getCurrentHero() != Hero.SOLDIER
    @Condition angleBetweenVectors(victim.getFacingDirection() * vect(1, 0, 1), eventDirection * vect(1, 0, 1)) <= 90
    
    #Deal lethal damage
    damage(victim, eventPlayer, 2000)
    eventPlayer.LastDamageDealt = 500


rule "Invisible on RMB (or Q) - Third Person":
    @Event eachPlayer
    @Hero mccree
    @Condition (eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.isHoldingButton(Button.ULTIMATE)) == true
    
    #If player was already invisible
    if eventPlayer.Invisible != 0:
        Decloak()
    else:
        #Not burning, not on objective, and has more than 5% cloak charge
        if eventPlayer.getUltCharge() >= 5 and not eventPlayer.isOnObjective() and not eventPlayer.hasStatusEffect(Status.BURNING):
            playEffect(getPlayers(eventPlayer.getTeam()), DynamicEffect.REAPER_WRAITH_FORM_SOUND, Color.WHITE, eventPlayer, 100)
            createEffect(eventPlayer, Effect.MOIRA_COALESCENCE_SOUND, Color.WHITE, eventPlayer, 100, EffectReeval.POSITION_AND_RADIUS)
            eventPlayer.InvisEffectArray[1] = getLastCreatedEntity()
            if eventPlayer.ThirdPersonEnabled:
                #Switch to 3rd person camera
                eventPlayer.startCamera(eventPlayer.getEyePosition() + worldVector(vect(1, 0, -1.5), eventPlayer, Transform.ROTATION), eventPlayer.getEyePosition() + worldVector(vect(1, 0, -1.5), eventPlayer, Transform.ROTATION) + eventPlayer.getFacingDirection(), 22)
            eventPlayer.Invisible = 0.5
            wait(0.01)
            eventPlayer.SpyCloakFlicker = true
            hudHeader(eventPlayer, "Cloaking...", HudPosition.RIGHT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
            eventPlayer.InvisTextArray[1] = getLastCreatedText()
            eventPlayer.setPrimaryFireEnabled(false)
            eventPlayer.setMeleeEnabled(false)
            wait(1)
            createEffect(getPlayers(eventPlayer.getTeam()), Effect.RING, Color.VIOLET, updateEveryTick(eventPlayer.getPosition()), 0.7, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.InvisEffectArray[0] = getLastCreatedEntity()
            #Clear "Cloaking..." from HUD
            destroyHudText(eventPlayer.InvisTextArray[1])
            eventPlayer.Invisible = 1
            hudHeader(eventPlayer, "Invisible", HudPosition.RIGHT, 0, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
            eventPlayer.InvisTextArray[1] = getLastCreatedText()
            eventPlayer.SpyCloakFlicker = false
            if eventPlayer.Disguised:
                eventPlayer.Bot1.setInvisibility(Invis.ALL)
            else:
                eventPlayer.setInvisibility(Invis.ALL)


rule "While cloak is active and player is moving, drain ult charge":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.Invisible == 1
    @Condition eventPlayer.getThrottle() != vect(0, 0, 0)
    
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() - 1)
    wait(0.066, Wait.ABORT_WHEN_FALSE)
    if RULE_CONDITION:
        goto RULE_START


rule "While cloak is inactive or player not moving, regen ult charge":
    @Event eachPlayer
    @Hero mccree
    @Condition (eventPlayer.Invisible != 1 or eventPlayer.getThrottle() == vect(0, 0, 0)) == true
    
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 1)
    wait(0.15)
    if RULE_CONDITION:
        goto RULE_START


rule "Charge cloak to full in spawn room":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isInSpawnRoom() == true
    
    eventPlayer.setUltCharge(100)


rule "When cloak runs out, force decloak":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.getUltCharge() <= 1
    @Condition eventPlayer.Invisible == 1
    
    Decloak()


def Decloak():
    @Name "Decloak (subroutine)"
    
    eventPlayer.SpyCloakFlicker = true
    eventPlayer.Invisible = 0.5
    #Clear "Invisible" from HUD
    destroyHudText(eventPlayer.InvisTextArray[1])
    #Add "Decloaking" to HUD
    hudHeader(eventPlayer, "Decloaking...", HudPosition.RIGHT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.InvisTextArray[1] = getLastCreatedText()
    #Create red smoke visible to everyone
    #createEffect(getAllPlayers(), Effect.BAD_AURA, Color.RED, eventPlayer, 0.6, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #eventPlayer.InvisEffectArray[1] = getLastCreatedEntity()
    #Clear purple ring
    destroyEffect(eventPlayer.InvisEffectArray[0])
    wait(2)
    #Clear "Decloaking..." from HUD
    destroyHudText(eventPlayer.InvisTextArray[1])
    #Clear Moira cloak sound
    destroyEffect(eventPlayer.InvisEffectArray[1])
    eventPlayer.SpyCloakFlicker = false
    #Clear red smoke
    #destroyEffect(eventPlayer.InvisEffectArray[1])
    #Clear Red HUD effect
    #destroyEffect(eventPlayer.InvisEffectArray[2])
    #Re-enable revolver
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.Invisible = 0
    if eventPlayer.Disguised:
        if eventPlayer.ThirdPersonEnabled:
            eventPlayer.Bot1.setInvisibility(Invis.NONE)
        else:
            eventPlayer.Bot1.setInvisibility(Invis.ENEMIES)
    else:
        eventPlayer.setInvisibility(Invis.NONE)
        #Switch back to 1st-person camera
        eventPlayer.stopCamera()


rule "Force decloak while on objective":
    @Event eachPlayer
    @Condition eventPlayer.isOnObjective() == true
    @Condition (eventPlayer.Invisible == 1 or eventPlayer.Invisible == 0.5) == true
    
    Decloak()


rule "Flicker logic - Cloak flash while cloaking/decloaking/damage/bump (toggleable with SpyCloakFlicker boolean)":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.SpyCloakFlicker == true
    
    while eventPlayer.SpyCloakFlicker:
        if eventPlayer.Disguised:
            if eventPlayer.ThirdPersonEnabled:
                eventPlayer.Bot1.setInvisibility(Invis.NONE)
            else:
                eventPlayer.Bot1.setInvisibility(Invis.ENEMIES)
        else:
            eventPlayer.setInvisibility(Invis.NONE)
        wait(0.1, Wait.ABORT_WHEN_FALSE)
        if eventPlayer.Disguised:
            eventPlayer.Bot1.setInvisibility(Invis.ALL)
        else:
            eventPlayer.setInvisibility(Invis.ALL)
        wait(0.05, Wait.ABORT_WHEN_FALSE)


rule "On death - clear all invis text/effects, make player visible, destroy disguise bot, reset camera":
    @Event playerDied
    @Hero mccree
    
    eventPlayer.setInvisibility(Invis.NONE)
    #clear cloaking/invisible/decloaking HUD text
    destroyHudText(eventPlayer.InvisTextArray[1])
    #clear Moira cloak sound
    destroyEffect(eventPlayer.InvisEffectArray[1])
    #clear purple ring
    destroyEffect(eventPlayer.InvisEffectArray[0])
    destroyDummy(eventPlayer.getTeam(), eventPlayer.Bot1.getSlot())
    eventPlayer.stopCamera()


rule "Electro-sapper on sentry melee":
    @Event playerDealtDamage
    @Hero mccree
    @Condition eventAbility == Button.MELEE
    @Condition eventPlayer.Invisible == false
    @Condition victim.getCurrentHero() == Hero.BASTION
    
    victim.setStatusEffect(eventPlayer, Status.STUNNED, 9999)
    victim.startDoT(null, 9999, 25)
    victim.SapperDOTID = getLastDoT()
    victim.BotOwner.BuildingSappedArray[1] = 2
    createEffect(getAllPlayers(), Effect.WINSTON_TESLA_CANNON_SOUND, Color.WHITE, victim, 100, EffectReeval.NONE)
    victim.BotOwner.SapperEffects[0] = getLastCreatedEntity()


rule "Flicker when colliding with enemy":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.Invisible == 1
    #@Condition [player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(eventPlayer.getPosition(), player.getPosition()) <= 1.4] != []
    @Condition ([i for i in [player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if not player.isDummy()] if distance(eventPlayer, i) <= 1.4]) != []
    
    eventPlayer.SpyCloakFlicker = true
    eventPlayer.Invisible = 0.5
    waitUntil([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(eventPlayer.getPosition(), player.getPosition()) <= 1.4] == [], 999)
    if eventPlayer.Invisible == true and eventPlayer.TimeSinceLastDamage >= 0.5:
        wait(0.5)
        eventPlayer.SpyCloakFlicker = false
        eventPlayer.setInvisibility(Invis.ALL)
        eventPlayer.Invisible = 1


rule "Flicker on damage":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.Invisible == true
    @Condition eventPlayer.TimeSinceLastDamage < 0.5
    
    eventPlayer.SpyCloakFlicker = true
    eventPlayer.Invisible = 0.5


rule "Stop flickering on no damage for 0.5s":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.Invisible != 0
    @Condition eventPlayer.TimeSinceLastDamage >= 0.5
    
    if len([player for player in getPlayersInRadius(eventPlayer, 1.4, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF) if player.isAlive()]) == 0:
        eventPlayer.SpyCloakFlicker = false
        eventPlayer.setInvisibility(Invis.ALL)
        eventPlayer.Invisible = 1


rule "E to cycle disguises":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    
    if eventPlayer.DisguiseSelection == Hero.REAPER:
        eventPlayer.DisguiseSelection = Hero.PHARAH
    elif eventPlayer.DisguiseSelection == Hero.PHARAH:
        eventPlayer.DisguiseSelection = Hero.MEI
    elif eventPlayer.DisguiseSelection == Hero.MEI:
        eventPlayer.DisguiseSelection = Hero.JUNKRAT
    elif eventPlayer.DisguiseSelection == Hero.JUNKRAT:
        eventPlayer.DisguiseSelection = Hero.DVA
    elif eventPlayer.DisguiseSelection == Hero.DVA:
        eventPlayer.DisguiseSelection = Hero.TORBJORN
    elif eventPlayer.DisguiseSelection == Hero.TORBJORN:
        eventPlayer.DisguiseSelection = Hero.MERCY
    elif eventPlayer.DisguiseSelection == Hero.MERCY:
        eventPlayer.DisguiseSelection = Hero.WIDOWMAKER
    elif eventPlayer.DisguiseSelection == Hero.WIDOWMAKER:
        eventPlayer.DisguiseSelection = Hero.MCCREE
    elif eventPlayer.DisguiseSelection == Hero.MCCREE:
        eventPlayer.DisguiseSelection = Hero.REAPER


rule "Disguise - Shift to activate":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition (not eventPlayer.Disguised or eventPlayer.Bot1.getCurrentHero() != eventPlayer.DisguiseSelection) == true
    #@Condition eventPlayer.isInSpawnRoom() == false
    
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setMeleeEnabled(false)
    if eventPlayer.ThirdPersonEnabled:
        eventPlayer.startCamera(eventPlayer.getEyePosition() + worldVector(vect(1, 0, -1.5), eventPlayer, Transform.ROTATION), raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 1000, getAllPlayers(), eventPlayer, true).getHitPosition(), 22)
    #Switch to 3rd person camera
    #eventPlayer.startCamera(eventPlayer.getEyePosition() + worldVector(vect(1, 0, -1.5), eventPlayer, Transform.ROTATION), eventPlayer.getEyePosition() + worldVector(vect(1, 0, -1.5), eventPlayer, Transform.ROTATION) + eventPlayer.getFacingDirection(), 22)
    createEffect(eventPlayer, Effect.ORISA_HALT_TENDRIL_SOUND, Color.WHITE, eventPlayer, 100, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.InvisEffectArray[6] = getLastCreatedEntity()
    if eventPlayer.Bot1.isDummy():
        createEffect(getAllPlayers(), Effect.SIGMA_GRAVITIC_FLUX_TARGET, Color.WHITE, eventPlayer.Bot1, 100, EffectReeval.POSITION_AND_RADIUS)
        eventPlayer.InvisEffectArray[5] = getLastCreatedEntity()
        wait(0.5)
        destroyDummy(getOppositeTeam(eventPlayer.getTeam()), eventPlayer.Bot1.getSlot())
    else:
        createEffect(getAllPlayers(), Effect.SIGMA_GRAVITIC_FLUX_TARGET, Color.WHITE, eventPlayer, 100, EffectReeval.POSITION_AND_RADIUS)
        eventPlayer.InvisEffectArray[5] = getLastCreatedEntity()
        wait(2)
    eventPlayer.Disguised = true
    destroyEffect(eventPlayer.InvisEffectArray[5])
    destroyEffect(eventPlayer.InvisEffectArray[6])
    createDummy(eventPlayer.DisguiseSelection, getOppositeTeam(eventPlayer.getTeam()), -1, eventPlayer, eventPlayer.getFacingDirection())
    eventPlayer.Bot1 = getLastCreatedEntity()
    if eventPlayer.Invisible != 0:
        eventPlayer.Bot1.setInvisibility(Invis.ALL)
    eventPlayer.Bot1.disablePlayerCollision()
    eventPlayer.Bot1.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.Bot1.startFacing(eventPlayer.getFacingDirection(), 9999, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    eventPlayer.attachTo(eventPlayer.Bot1, vect(0, 0, 0))
    if eventPlayer.getThrottle() != vect(0, 0, 0):
        eventPlayer.Bot1.startThrottleInDirection(eventPlayer.getThrottle(), 1, Relativity.TO_PLAYER, Throttle.REPLACE_EXISTING, ThrottleReeval.DIRECTION_AND_MAGNITUDE)
    eventPlayer.setInvisibility(Invis.ALL)
    #createInWorldText(getAllPlayers(), "{0} (Friendly Spy)".format(eventPlayer), eventPlayer.Bot1.getEyePosition() + vect(0, 0.25, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers(), eventPlayer, eventPlayer.Bot1, 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)
    #createInWorldText([player for player in getPlayers(eventPlayer.getTeam()) if player != eventPlayer], "{0} (Friendly Spy)".format(eventPlayer), eventPlayer.Bot1.getEyePosition() + vect(0, 1, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.InvisEffectArray[5] = getLastCreatedEntity()
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setMeleeEnabled(true)
    if (len([i for i in [player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if not player.isDummy()] if i.getCurrentHero() == eventPlayer.DisguiseSelection])) != 0:
        eventPlayer.Bot1.startForcingName(([i for i in [player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if not player.isDummy()] if i.getCurrentHero() == eventPlayer.DisguiseSelection])[0])
    else:
        eventPlayer.Bot1.startForcingName(random.choice([player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if not player.isDummy()]))


rule "DisguiseBot - Start Crouch":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    
    eventPlayer.Bot1.startForcingButton(Button.CROUCH)


rule "DisguiseBot - Stop Crouch":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == false
    
    eventPlayer.Bot1.stopForcingButton(Button.CROUCH)


rule "DisguiseBot - Jump":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.Bot1.forceButtonPress(Button.JUMP)


rule "Disguisebot - Stop moving":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.getThrottle() == vect(0, 0, 0)
    
    eventPlayer.Bot1.stopThrottleInDirection()
    #eventPlayer.Bot1.teleport(eventPlayer)


rule "Disguisebot - Move with player":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.getThrottle() != vect(0, 0, 0)
    
    eventPlayer.Bot1.startThrottleInDirection(eventPlayer.getThrottle(), 1, Relativity.TO_PLAYER, Throttle.REPLACE_EXISTING, ThrottleReeval.DIRECTION_AND_MAGNITUDE)
    #eventPlayer.Bot1.teleport(eventPlayer + eventPlayer.getFacingDirection())
    #while true:
    #eventPlayer.Bot1.teleport(eventPlayer)
    #wait(0.25, Wait.ABORT_WHEN_FALSE)
    #__end__()


rule "Attacking drops disguise":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.Disguised == true
    @Condition (eventPlayer.isFiringPrimaryFire() or eventPlayer.isMeleeing()) == true
    
    eventPlayer.Disguised = false
    eventPlayer.TargetableBySentry = true
    destroyDummy(getOppositeTeam(eventPlayer.getTeam()), eventPlayer.Bot1.getSlot())
    eventPlayer.Bot1 = null
    eventPlayer.stopCamera()
    destroyInWorldText(eventPlayer.InvisEffectArray[5])
    eventPlayer.setInvisibility(Invis.NONE)


rule "Set HealTarget/BeingHealed ---------------------------------- Medic / Mercy -------------------------------------------":
    @Event playerReceivedHealing
    @Condition healer.getCurrentHero() == Hero.MERCY
    @Condition healer != eventPlayer
    
    eventPlayer.BeingHealed = true
    healer.HealTarget = eventPlayer
    eventPlayer.Healer = healer
    eventPlayer.TimeSinceMercyHealed = 0
    chase(eventPlayer.TimeSinceMercyHealed, 1, duration=1, ChaseReeval.NONE)
    #If healer is ubercharged
    if healer.Ubercharged == true:
        #Healee gets ubercharged too
        eventPlayer.Ubercharged = true


rule "Set not healing":
    @Event eachPlayer
    @Condition eventPlayer.TimeSinceMercyHealed >= 0.25
    
    eventPlayer.BeingHealed = false
    eventPlayer.Healer = null
    if eventPlayer.Healer.HealTarget == eventPlayer:
        eventPlayer.Healer.HealTarget = null
    if eventPlayer.getCurrentHero() != Hero.MERCY:
        eventPlayer.Ubercharged = false


rule "HealBeam Breaks (set HealTarget = Null)":
    @Event eachPlayer
    @Hero mercy
    #If LOS breaks or distance becomes greater than 15.51 meters
    @Condition (not isInLoS(eventPlayer.getEyePosition(), eventPlayer.HealTarget.getEyePosition(), BarrierLos.PASS_THROUGH_BARRIERS) or distance(eventPlayer.getEyePosition(), eventPlayer.HealTarget.getEyePosition()) > 15.51) == true
    
    wait(1.7, Wait.ABORT_WHEN_FALSE)
    #Remove uber if ubered
    if eventPlayer.Ubercharged:
        eventPlayer.HealTarget.Ubercharged = false
    eventPlayer.HealTarget.BeingHealed = false
    stopHoT(eventPlayer.HealTarget.HealTargetHealOverTimeID)
    eventPlayer.HealTarget = null


rule "Overheal":
    @Event eachPlayer
    #Have Full Health
    @Condition eventPlayer.getNormalizedHealth() >= 1
    #Not at Max Overheal
    @Condition eventPlayer.OverhealPool < eventPlayer.OverhealMaxPool
    #Being healed by a Mercy
    @Condition eventPlayer.BeingHealed == true
    
    chase(eventPlayer.OverhealPool, eventPlayer.OverhealMaxPool, rate=50, ChaseReeval.DESTINATION_AND_RATE)
    #chase(eventPlayer.HealTarget.OverhealPool, eventPlayer.getMaxHealth() * 0.5, duration=3, ChaseReeval.DESTINATION_AND_DURATION)
    #eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.OverhealPool, true, true)


rule "Overheal Decay":
    @Event eachPlayer
    @Condition eventPlayer.BeingHealed == false
    @Condition eventPlayer.OverhealPool > 0
    
    chase(eventPlayer.OverhealPool, 0, rate=10, ChaseReeval.NONE)


rule "Medic Dies, set Uber to zero":
    @Event playerDied
    @Hero mercy
    
    eventPlayer.setUltCharge(0)


rule "Mercy (Medic) - Ubercharge on Q Press AND Ubercharge End":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.getUltCharge() == 100
    
    eventPlayer.setUltCharge(0)
    #Set Ubercharged variable true
    eventPlayer.Ubercharged = true
    #If there is a player being healed
    if eventPlayer.HealTarget != null:
        #Set them Ubercharged too
        eventPlayer.HealTarget.Ubercharged = true
    #Expires after 8s
    wait(8)
    #Set Ubercharged variable false
    eventPlayer.Ubercharged = false
    #If there is a player being healed
    if eventPlayer.HealTarget != null:
        #Disable their Ubercharged too
        eventPlayer.HealTarget.Ubercharged = false


rule "Start Ubercharge Effects":
    @Event eachPlayer
    @Condition eventPlayer.Ubercharged == true
    
    #Go invincible 10s
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 8)
    #Create alert message that uber is active
    bigMessage(eventPlayer, "UBERCHARGE ACTIVE, YOU ARE INVULNERABLE!")
    createEffect(getAllPlayers(), Effect.ENERGY_SOUND, Color.WHITE, eventPlayer, 100, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.UberchargeEffectArray = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.SPARKLES, Color.WHITE, eventPlayer, 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.UberchargeEffectArray.append(getLastCreatedEntity())
    #createEffect(getAllPlayers(), Effect.SPHERE, Color.YELLOW, eventPlayer, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #eventPlayer.UberchargeEffectArray.append(getLastCreatedEntity())
    createEffect(eventPlayer, Effect.LIGHT_SHAFT, Color.YELLOW, eventPlayer, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.UberchargeEffectArray.append(getLastCreatedEntity())
    #eventPlayer.startCamera(eventPlayer.getEyePosition() + worldVector(vect(1, 0, -1.5), eventPlayer, Transform.ROTATION), raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 1000, getAllPlayers(), eventPlayer, true).getHitPosition(), 22)


rule "End Ubercharge Effects":
    @Event eachPlayer
    @Condition eventPlayer.Ubercharged == false
    
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    for eventPlayer.Index in range(len(eventPlayer.UberchargeEffectArray)):
        destroyEffect(eventPlayer.UberchargeEffectArray[eventPlayer.Index])
    eventPlayer.UberchargeEffectArray = null
    eventPlayer.HealTarget.Ubercharged = false
    eventPlayer.stopCamera()


rule "Mercy Passive Self-Heal (reset ramp on damage)":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.TimeSinceLastDamage <= 1
    
    stopHoT(eventPlayer.MercyHealOverTimeID)
    eventPlayer.startHoT(eventPlayer, 3.333, 3)
    eventPlayer.MercyHealOverTimeID = getLastHoT()
    wait(3.333, Wait.RESTART_WHEN_TRUE)
    eventPlayer.startHoT(eventPlayer, 3.333, 4)
    eventPlayer.MercyHealOverTimeID = getLastHoT()
    wait(3.333, Wait.RESTART_WHEN_TRUE)
    eventPlayer.startHoT(eventPlayer, 3.333, 5)
    eventPlayer.MercyHealOverTimeID = getLastHoT()
    wait(3.333, Wait.RESTART_WHEN_TRUE)
    eventPlayer.startHoT(eventPlayer, 9999, 6)
    eventPlayer.MercyHealOverTimeID = getLastHoT()


rule "Mercy Max Healing Ramp 2x (48 HP/s)":
    @Event eachPlayer
    @Condition (eventPlayer.TimeSinceLastDamage >= 5 and eventPlayer.TimeSinceLastDamage) < 10
    @Condition eventPlayer.BeingHealed == true
    
    stopHoT(eventPlayer.HealTargetHealOverTimeID)
    eventPlayer.startHoT(eventPlayer, 9999, 24)
    eventPlayer.HealTargetHealOverTimeID = getLastHoT()


rule "Mercy Max Healing Ramp 3x (72 HP/s)":
    @Event eachPlayer
    @Condition eventPlayer.TimeSinceLastDamage >= 10
    @Condition eventPlayer.BeingHealed == true
    
    stopHoT(eventPlayer.HealTargetHealOverTimeID)
    eventPlayer.startHoT(eventPlayer, 9999, 48)
    eventPlayer.HealTargetHealOverTimeID = getLastHoT()


rule "Stop Mercy Max Healing Ramp when healing ends/damage taken (reset to 24 HP/s)":
    @Event eachPlayer
    @Condition (not eventPlayer.BeingHealed or eventPlayer.TimeSinceLastDamage < 5) == true
    
    stopHoT(eventPlayer.HealTargetHealOverTimeID)


rule "AllowDoubleJump----------------------------------------------- Scout / Reaper --------------------------------------------":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.getAltitude() > 0.8
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.NumOfDoubleJumps > 0
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.AllowDoubleJump = true


rule "Disallow doublejump if you are out of jumps":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.NumOfDoubleJumps <= 0
    
    eventPlayer.AllowDoubleJump = false


rule "If you jump in the air and doublejump is allowed, double jump and consume a charge":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.AllowDoubleJump == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.applyImpulse(Vector.UP, 8, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.NumOfDoubleJumps -= 1


rule "Touching the ground resets jump count and disallows doublejump":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isInAir() == true
    
    eventPlayer.NumOfDoubleJumps = 1
    eventPlayer.AllowDoubleJump = false


rule "Automatic Reloading":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isFiringPrimaryFire() == false
    @Condition eventPlayer.getAmmo(0) < 6
    #@Condition eventPlayer.StickyOrFlaregunEquipped == false
    
    wait(0.825, Wait.ABORT_WHEN_FALSE)
    while eventPlayer.getAmmo(0) < 6:
        wait(0.5, Wait.ABORT_WHEN_FALSE)
        eventPlayer.setAmmo(0, eventPlayer.getAmmo(0) + 1)
        playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR_SOUND, Color.WHITE, eventPlayer, 100)


rule "E to Switch Weapon ----------------------------------------- Demoman / Junkrat -----------------------------------------":
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isAlive() == true
    
    if eventPlayer.StickyOrFlaregunEquipped:
        eventPlayer.setPrimaryFireEnabled(true)
        eventPlayer.StickyOrFlaregunEquipped = false
        destroyHudText(eventPlayer.ClassGuideHUDTextArray[0])
        hudText(getAllPlayers(), "Pipebomb Launcher", null, "(E) Switch", HudPosition.TOP, 0, Color.BLUE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        eventPlayer.ClassGuideHUDTextArray[0] = getLastCreatedText()
    else:
        eventPlayer.setPrimaryFireEnabled(false)
        eventPlayer.StickyOrFlaregunEquipped = true
        destroyHudText(eventPlayer.ClassGuideHUDTextArray[0])
        hudText(getAllPlayers(), "Stickybomb Launcher", null, "(E) Switch", HudPosition.TOP, 0, Color.BLUE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        eventPlayer.ClassGuideHUDTextArray[0] = getLastCreatedText()


rule "Launch Stickybomb / Detonate first sticky if this is 9th sticky":
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.StickyOrFlaregunEquipped == true
    @Condition eventPlayer.MovingBombEffect == null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.StickyAmmo > 0
    
    #Wait a frame to make sure this executes after reload finishes its loop otherwise it will continue looping while player is holding LMB on 0 ammo
    wait()
    if len(eventPlayer.StuckBombsArray) >= 9:
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.StuckBombLocationsArray[1], 1.5)
        playEffect(getAllPlayers(), DynamicEffect.MCCREE_FLASHBANG_EXPLOSION_SOUND, Color.ORANGE, eventPlayer.StuckBombLocationsArray[1], 100)
        destroyEffect(eventPlayer.StuckBombsArray[1])
        #Set PlayersInBlastRadius to all players within 2m of sticky
        eventPlayer.PlayersInBlastRadiusArray = getPlayersInRadius(eventPlayer.StuckBombLocationsArray[1], 2.8, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF)
        if distance(eventPlayer, eventPlayer.StuckBombLocationsArray[1]) <= 2.8:
            eventPlayer.PlayersInBlastRadiusArray.append(eventPlayer)
        for eventPlayer.Index2 in range(len(eventPlayer.PlayersInBlastRadiusArray)):
            eventPlayer.DistanceFromBlastScalar = 2.8 - distance(eventPlayer.PlayersInBlastRadiusArray[eventPlayer.Index2], eventPlayer.StuckBombLocationsArray[1])
            eventPlayer.PlayersInBlastRadiusArray[eventPlayer.Index2].applyImpulse(vectorTowards(eventPlayer.StuckBombLocationsArray[1], eventPlayer.PlayersInBlastRadiusArray[eventPlayer.Index2].getEyePosition()), eventPlayer.DistanceFromBlastScalar * 10, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            #Damage between 60 and 144 based on distance from grenade
            damage(eventPlayer.PlayersInBlastRadiusArray[eventPlayer.Index2], eventPlayer, 60 + 30 * eventPlayer.DistanceFromBlastScalar)
        del eventPlayer.StuckBombsArray[1]
        del eventPlayer.StuckBombLocationsArray[1]
    eventPlayer.BombDestination = (raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 1000, getPlayers(getOppositeTeam(eventPlayer.getTeam())), null, true).getNormal()) * 0.05 + (raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 1000, getPlayers(getOppositeTeam(eventPlayer.getTeam())), null, true).getHitPosition())
    #eventPlayer.BombDestination = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 1000, getPlayers(getOppositeTeam(eventPlayer.getTeam())), null, true).getHitPosition()
    eventPlayer.BombPosition = eventPlayer.getEyePosition()
    #Create moving stickybomb projectile
    createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, eventPlayer.BombPosition, 0.08, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #update every frame doesn't work because stickies are too small
    #createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, updateEveryTick(eventPlayer.BombPosition), 0.08, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.MovingBombEffect = getLastCreatedEntity()
    chase(eventPlayer.BombPosition, eventPlayer.BombDestination, rate=30, ChaseReeval.DESTINATION_AND_RATE)
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    eventPlayer.StickyAmmo -= 1
    wait(0.6)
    if RULE_CONDITION:
        goto RULE_START


rule "Stickybomb stuck":
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer.BombPosition == eventPlayer.BombDestination
    
    destroyEffect(eventPlayer.MovingBombEffect)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.ORANGE, eventPlayer.BombDestination, 0.08, EffectReeval.NONE)
    eventPlayer.StuckBombsArray.append(getLastCreatedEntity())
    eventPlayer.StuckBombLocationsArray.append(eventPlayer.BombDestination)
    eventPlayer.MovingBombEffect = null


rule "Detonate Stickybombs":
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.isAlive() == true
    
    #For each sticky
    for eventPlayer.Index in range(1, len(eventPlayer.StuckBombsArray)):
        #Play visual explosion effect
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, eventPlayer.StuckBombLocationsArray[eventPlayer.Index], 1.5)
        #Play sound effect
        playEffect(getAllPlayers(), DynamicEffect.MCCREE_FLASHBANG_EXPLOSION_SOUND, Color.ORANGE, eventPlayer.StuckBombLocationsArray[eventPlayer.Index], 100)
        destroyEffect(eventPlayer.StuckBombsArray[eventPlayer.Index])
        #Set PlayersInBlastRadius to all players within 2m of sticky
        eventPlayer.PlayersInBlastRadiusArray = getPlayersInRadius(eventPlayer.StuckBombLocationsArray[eventPlayer.Index], 2.8, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF)
        for eventPlayer.Index2 in range(len(eventPlayer.PlayersInBlastRadiusArray)):
            eventPlayer.DistanceFromBlastScalar = 2.8 - distance(eventPlayer.PlayersInBlastRadiusArray[eventPlayer.Index2], eventPlayer.StuckBombLocationsArray[eventPlayer.Index])
            #Original working knockback
            eventPlayer.PlayersInBlastRadiusArray[eventPlayer.Index2].applyImpulse(vectorTowards(eventPlayer.StuckBombLocationsArray[eventPlayer.Index], eventPlayer.PlayersInBlastRadiusArray[eventPlayer.Index2].getEyePosition()), eventPlayer.DistanceFromBlastScalar * 4, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            wait(0.025)
            #Damage between 60 and 144 based on distance from grenade
            damage(eventPlayer.PlayersInBlastRadiusArray[eventPlayer.Index2], eventPlayer, 60 + 30 * eventPlayer.DistanceFromBlastScalar)
        #Stickyjump Logic
        if distance(eventPlayer.StuckBombLocationsArray[eventPlayer.Index], eventPlayer.getEyePosition()) <= 3.3:
            eventPlayer.DistanceFromBlastScalar = 3.3 - distance(eventPlayer, eventPlayer.StuckBombLocationsArray[eventPlayer.Index])
            #Apply Vertical Thrust
            eventPlayer.applyImpulse(Vector.UP, (abs(directionTowards(eventPlayer.StuckBombLocationsArray[eventPlayer.Index], eventPlayer).y) + 1) * 11, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            #Apply Horizontal Thrust
            eventPlayer.applyImpulse(normalize(vectorTowards(eventPlayer.StuckBombLocationsArray[eventPlayer.Index], eventPlayer)) * vect(1, 0, 1), 20 * (1 - normalize(vectorTowards(eventPlayer.StuckBombLocationsArray[eventPlayer.Index], eventPlayer)).y), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            #Damage between 60 and 144 based on distance from grenade
            damage(eventPlayer, eventPlayer, 30 + 25 * eventPlayer.DistanceFromBlastScalar)
    eventPlayer.StuckBombsArray = null
    eventPlayer.StuckBombLocationsArray = null


rule "Automatic Reloading (Pipebomb Launcher)":
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer.isFiringPrimaryFire() == false
    @Condition eventPlayer.getAmmo(0) < 4
    @Condition eventPlayer.StickyOrFlaregunEquipped == false
    
    wait(1.24, Wait.ABORT_WHEN_FALSE)
    while true:
        wait(0.6, Wait.ABORT_WHEN_FALSE)
        eventPlayer.setAmmo(0, eventPlayer.getAmmo(0) + 1)
        playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR_SOUND, Color.WHITE, eventPlayer, 100)


rule "Automatic Reloading (Stickybomb Launcher)":
    @Event eachPlayer
    @Hero junkrat
    #Fire isn't held or ammo is depleted
    @Condition (eventPlayer.StickyAmmo == 0 or not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)) == true
    @Condition eventPlayer.StickyAmmo < 8
    @Condition eventPlayer.StickyOrFlaregunEquipped == true
    
    wait(1.02, Wait.ABORT_WHEN_FALSE)
    while true:
        wait(0.67, Wait.ABORT_WHEN_FALSE)
        playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR_SOUND, Color.WHITE, eventPlayer, 100)
        eventPlayer.StickyAmmo += 1


rule "Junkrat dies, reset sticky ammo to 8 and disable damage from passive bombs":
    @Event playerDied
    @Hero junkrat
    
    eventPlayer.StickyAmmo = 8
    eventPlayer.setDamageDealt(0)
    #For each sticky
    for eventPlayer.Index in range(1, len(eventPlayer.StuckBombsArray) - 1):
        destroyEffect(eventPlayer.StuckBombsArray[eventPlayer.Index])
    eventPlayer.StuckBombsArray = null
    eventPlayer.StuckBombLocationsArray = null


rule "Re-enable damage on respawn":
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer.isAlive() == true
    
    eventPlayer.setDamageDealt(83.4)


rule "Dealing damage charges ult, 600dmg = full charge ------- Soldier / Pharah -----------------------------------------":
    @Event playerDealtDamage
    @Hero pharah
    @Condition victim.getTeam() != eventPlayer.getTeam()
    
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + eventDamage * 0.168)


rule "Dying sets Buff Banner charge to zero":
    @Event playerDied
    @Hero pharah
    
    eventPlayer.setUltCharge(0)


rule "Activate Buff Banner":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.getUltCharge() == 100
    
    eventPlayer.setUltCharge(0)
    bigMessage(eventPlayer, "Sounding Buff Banner!")
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    eventPlayer.setPrimaryFireEnabled(false)
    createEffect(getAllPlayers(), Effect.MCCREE_FLASHBANG_STUNNED, Color.RED, eventPlayer, 1, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.BuffBannerEffectsArray[0] = getLastCreatedEntity()
    wait(3)
    eventPlayer.setPrimaryFireEnabled(true)
    destroyEffect(eventPlayer.BuffBannerEffectsArray[0])
    createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.ORANGE, eventPlayer, 1, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.BuffBannerEffectsArray[0] = getLastCreatedEntity()
    eventPlayer.BuffBannerActive = true
    #Apply damage buff 35% bonus
    startDamageModification(getPlayers(getOppositeTeam(eventPlayer.getTeam())), getPlayersInRadius(eventPlayer.getEyePosition(), 8.57, eventPlayer.getTeam(), LosCheck.OFF), 135, DamageReeval.RECEIVERS_AND_DAMAGERS)
    eventPlayer.BuffBannerDamageModID = getLastDamageModification()
    wait(10)
    destroyEffect(eventPlayer.BuffBannerEffectsArray[0])
    eventPlayer.BuffBannerActive = false
    stopDamageModification(eventPlayer.BuffBannerDamageModID)


rule "Beam effect to Pharah":
    @Event eachPlayer
    #A nearby player has a buff banner active
    @Condition len([player for player in getPlayersInRadius(eventPlayer, 8.57, eventPlayer.getTeam(), LosCheck.OFF) if player.BuffBannerActive]) > 0
    #You do not have your own active buff banner
    @Condition eventPlayer.BuffBannerActive == false
    
    createBeam(getAllPlayers(), Beam.GOOD, eventPlayer, [player for player in getPlayersOnHero(Hero.PHARAH, eventPlayer.getTeam()) if player.BuffBannerActive][0], Color.ORANGE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.BuffBannerEffectsArray[0] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.ORANGE, eventPlayer, 1, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.BuffBannerEffectsArray[1] = getLastCreatedEntity()
    bigMessage(getAllPlayers(), "Buff banner active, dealing mini-crits")
    waitUntil(len([player for player in getPlayersInRadius(eventPlayer, 8.57, eventPlayer.getTeam(), LosCheck.OFF) if player.BuffBannerActive]) == 0, 99999)
    destroyEffect(eventPlayer.BuffBannerEffectsArray[0])
    destroyEffect(eventPlayer.BuffBannerEffectsArray[1])


rule "Rocket Jump increased self-knockback":
    @Event playerTookDamage
    @Hero pharah
    @Condition attacker == eventPlayer
    
    #Apply Vertical Thrust
    eventPlayer.applyImpulse(Vector.DOWN if eventDirection.y < 0 else Vector.UP, (abs(eventDirection.y) + 1) * 11, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    #Apply Horizontal Thrust
    eventPlayer.applyImpulse(eventDirection * vect(1, 0, 1), 20 * (1 - normalize(eventDirection).y), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)


rule "Automatic Reloading":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.isFiringPrimaryFire() == false
    @Condition eventPlayer.getAmmo(0) < 4
    
    wait(0.92, Wait.ABORT_WHEN_FALSE)
    while eventPlayer.getAmmo(0) < 4:
        wait(0.8, Wait.ABORT_WHEN_FALSE)
        eventPlayer.setAmmo(0, eventPlayer.getAmmo(0) + 1)
        playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR_SOUND, Color.WHITE, eventPlayer, 100)


rule "Press E to cycle buildables --------------------------------Engineer / Torbjorn ---------------------------------------":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    
    #Swap to none
    if eventPlayer.BuildingEquipped == "Teleporter Exit (Cost: 50)":
        #Set BuildableEquipped to Wrench (0)
        eventPlayer.BuildingEquipped = "None"
        #Hide ghost teleporter
        destroyEffect(eventPlayer.BuildingArray[0])
        #Hide rotation orientation icon
        destroyInWorldText(eventPlayer.BuildingArray[6])
        #Re-enable weapons
        eventPlayer.setPrimaryFireEnabled(true)
        eventPlayer.setSecondaryFireEnabled(true)
    elif eventPlayer.BuildingEquipped == "None":
        eventPlayer.BuildingEquipped = "Sentry Turret (Cost: 130)"
        eventPlayer.BuildingRotation = iconString(Icon.ARROW_UP)
        #Create ghost Sentry (update every frame)
        createEffect(eventPlayer, Effect.SPHERE, eventPlayer.BuildingGhostColor, updateEveryTick(raycast(eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2, eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2 + vect(0, -3, 0), getAllPlayers(), eventPlayer, true).getHitPosition() + vect(0, 0.45, 0)), 0.45, EffectReeval.POSITION_RADIUS_AND_COLOR)
        eventPlayer.BuildingArray[0] = getLastCreatedEntity()
        #Create Sentry range display
        createEffect(eventPlayer, Effect.SPHERE, Color.RED, updateEveryTick(raycast(eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2, eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2 + vect(0, -3, 0), getAllPlayers(), eventPlayer, true).getHitPosition() + vect(0, 0.45, 0)), 20.95, EffectReeval.POSITION_AND_RADIUS)
        eventPlayer.BuildingArray[5] = getLastCreatedEntity()
        #Create rotation orientation icon
        createInWorldText(eventPlayer, eventPlayer.BuildingRotation, updateEveryTick(raycast(eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2, eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2 + vect(0, -3, 0), getAllPlayers(), eventPlayer, true).getHitPosition() + vect(0, 0.45, 0)), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
        eventPlayer.BuildingArray[6] = getLastCreatedText()
        #Disable weapons
        eventPlayer.setPrimaryFireEnabled(false)
        eventPlayer.setSecondaryFireEnabled(false)
    elif eventPlayer.BuildingEquipped == "Sentry Turret (Cost: 130)":
        eventPlayer.BuildingEquipped = "Dispenser (Cost: 100)"
        destroyEffect(eventPlayer.BuildingArray[0])
        destroyEffect(eventPlayer.BuildingArray[5])
        destroyInWorldText(eventPlayer.BuildingArray[6])
        createEffect(eventPlayer, Effect.SPHERE, eventPlayer.BuildingGhostColor, updateEveryTick(raycast(eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2, eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2 + vect(0, -3, 0), getAllPlayers(), eventPlayer, true).getHitPosition() + vect(0, 0.55, 0)), 0.55, EffectReeval.POSITION_RADIUS_AND_COLOR)
        eventPlayer.BuildingArray[0] = getLastCreatedEntity()
    elif eventPlayer.BuildingEquipped == "Dispenser (Cost: 100)":
        eventPlayer.BuildingEquipped = "Teleporter Entrance (Cost: 50)"
        destroyEffect(eventPlayer.BuildingArray[0])
        createEffect(eventPlayer, Effect.RING, eventPlayer.BuildingGhostColor, updateEveryTick(raycast(eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2, eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2 + vect(0, -3, 0), getAllPlayers(), eventPlayer, true).getHitPosition() + vect(0, 0.05, 0)), 0.55, EffectReeval.POSITION_RADIUS_AND_COLOR)
        eventPlayer.BuildingArray[0] = getLastCreatedEntity()
        #Create down icon for TP Entrance
        createInWorldText(eventPlayer, iconString(Icon.ARROW_DOWN), updateEveryTick(raycast(eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2, eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2 + vect(0, -3, 0), getAllPlayers(), eventPlayer, true).getHitPosition() + vect(0, 0.05, 0)), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
        eventPlayer.BuildingArray[6] = getLastCreatedText()
    elif eventPlayer.BuildingEquipped == "Teleporter Entrance (Cost: 50)":
        eventPlayer.BuildingEquipped = "Teleporter Exit (Cost: 50)"
        eventPlayer.BuildingRotation = iconString(Icon.ARROW_UP)
        #Hide rotation orientation icon
        destroyInWorldText(eventPlayer.BuildingArray[6])
        #Create rotation orientation icon
        createInWorldText(eventPlayer, eventPlayer.BuildingRotation, updateEveryTick(raycast(eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2, eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2 + vect(0, -3, 0), getAllPlayers(), eventPlayer, true).getHitPosition() + vect(0, 0.05, 0)), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
        eventPlayer.BuildingArray[6] = getLastCreatedText()


rule "Shift to change building rotation":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition (eventPlayer.BuildingEquipped == "Sentry Turret (Cost: 130)" or eventPlayer.BuildingEquipped == "Teleporter Exit (Cost: 50)") == true
    
    if eventPlayer.BuildingRotation == iconString(Icon.ARROW_UP):
        eventPlayer.BuildingRotation = iconString(Icon.ARROW_RIGHT)
    elif eventPlayer.BuildingRotation == iconString(Icon.ARROW_RIGHT):
        eventPlayer.BuildingRotation = iconString(Icon.ARROW_DOWN)
    elif eventPlayer.BuildingRotation == iconString(Icon.ARROW_DOWN):
        eventPlayer.BuildingRotation = iconString(Icon.ARROW_LEFT)
    elif eventPlayer.BuildingRotation == iconString(Icon.ARROW_LEFT):
        eventPlayer.BuildingRotation = iconString(Icon.ARROW_UP)


rule "Check if current build location is valid":
    @Event eachPlayer
    @Hero torbjorn
    #Player must not be in spawn room
    @Condition eventPlayer.isInSpawnRoom() == false
    @Condition eventPlayer.BuildingEquipped != "None"
    #2.5m raycast in front of player must not hit anything
    @Condition raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2.75, getAllPlayers(), eventPlayer, true).getHitPosition() == eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2.75
    @Condition raycast(eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2.6, eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2.6 + vect(0, -2.5, 0), getAllPlayers(), eventPlayer, true).getHitPosition() != eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2.6 + vect(0, -2.5, 0)
    
    eventPlayer.BuildingGhostColor = Color.GREEN
    waitUntil(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2.75, getAllPlayers(), eventPlayer, true).getHitPosition() != eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2.75 or raycast(eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2.6, eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2.6 + vect(0, -2.5, 0), getAllPlayers(), eventPlayer, true).getHitPosition() == eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2.6 + vect(0, -2.5, 0) or eventPlayer.isInSpawnRoom() or eventPlayer.BuildingEquipped == 0, 99999)
    eventPlayer.BuildingGhostColor = Color.RED


rule "Press LMB to build":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.BuildingEquipped != "None"
    #@Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.BuildingGhostColor == Color.GREEN
    #No longer needed since check included in GhostColor
    #@Condition eventPlayer.isInSpawnRoom() == false
    
    #Building Sentry
    if eventPlayer.BuildingEquipped == "Sentry Turret (Cost: 130)" and eventPlayer.EngineerMetal >= 130:
        SwitchToWeapons()
        #Clear ghost sentry and range indicator
        destroyEffect(eventPlayer.BuildingArray[0])
        destroyEffect(eventPlayer.BuildingArray[5])
        destroyInWorldText(eventPlayer.BuildingArray[6])
        #Deduct 130 metal
        eventPlayer.EngineerMetal -= 130
        DestroySentry()
        #Switch back to weapons
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        InitializeSentry()
        #Building Dispenser
    elif eventPlayer.BuildingEquipped == "Dispenser (Cost: 100)" and eventPlayer.EngineerMetal >= 100:
        SwitchToWeapons()
        DestroyDispenser()
        #Clear ghost dispenser
        destroyEffect(eventPlayer.BuildingArray[0])
        #Deduct 100 metal
        eventPlayer.EngineerMetal -= 100
        InitializeDispenser()
        #Switch back to weapons
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        #Building TP Entrance
    elif eventPlayer.BuildingEquipped == "Teleporter Entrance (Cost: 50)" and eventPlayer.EngineerMetal >= 50:
        SwitchToWeapons()
        #Clear ghost TP
        destroyEffect(eventPlayer.BuildingArray[0])
        #Deduct 50 metal
        eventPlayer.EngineerMetal -= 50
        DestroyTPEntrance()
        InitializeTPEntrance()
        #Switch back to weapons
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        #Building TP Exit
    elif eventPlayer.BuildingEquipped == "Teleporter Exit (Cost: 50)" and eventPlayer.EngineerMetal >= 50:
        SwitchToWeapons()
        #Clear ghost TP
        destroyEffect(eventPlayer.BuildingArray[0])
        destroyInWorldText(eventPlayer.BuildingArray[6])
        #Deduct 50 metal
        eventPlayer.EngineerMetal -= 50
        DestroyTPExit()
        InitializeTPExit()
        #Switch back to weapons
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        #If nothing was built due to not enough metal
    else:
        playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 50)
        bigMessage(eventPlayer, "Not Enough Metal!")


rule "On weapon switch, re-enable weapons":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.getCurrentWeapon() != eventPlayer.TorbEquippedWeapon
    
    SwitchToWeapons()
    eventPlayer.TorbEquippedWeapon = eventPlayer.getCurrentWeapon()


def SwitchToWeapons():
    @Name "Switch to Weapons (Subroutine)"
    
    #Set BuildableEquipped to Wrench (0)
    eventPlayer.BuildingEquipped = "None"
    #Hide ghost building
    destroyEffect(eventPlayer.BuildingArray[0])
    #Hide ghost range indicator
    destroyEffect(eventPlayer.BuildingArray[5])
    destroyInWorldText(eventPlayer.BuildingArray[6])
    #Re-enable weapons
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)


rule "Dispenser - Resupply Engie Metal when nearby":
    @Event eachPlayer
    @Hero torbjorn
    @Condition distance(eventPlayer.getEyePosition(), eventPlayer.BuildingLocationsArray[2]) <= 5
    @Condition eventPlayer.DispenserMetal > 0
    @Condition eventPlayer.EngineerMetal < 200
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR_SOUND, Color.WHITE, eventPlayer, 100)
    #If not enough metal in Dispenser for a full tick
    if eventPlayer.DispenserMetal < 30 + eventPlayer.BuildingLevelArray[2] * 10:
        #If player does not have enough room for tick
        if eventPlayer.DispenserMetal >= 200 - eventPlayer.EngineerMetal:
            #Take metal out of disp equal to available player space
            eventPlayer.DispenserMetal -= 200 - eventPlayer.EngineerMetal
            #Set player metal to max
            eventPlayer.EngineerMetal = 200
            #If player does have room for reduced tick
        else:
            #Add all metal to engie's metal
            eventPlayer.EngineerMetal += eventPlayer.DispenserMetal
            #Set disp metal to zero
            eventPlayer.DispenserMetal = 0
        #If dispenser contains enough for a full tick
    else:
        #If player does not have enough room for full tick
        if 30 + eventPlayer.BuildingLevelArray[2] * 10 >= 200 - eventPlayer.EngineerMetal:
            #Take metal out of disp equal to available player space
            eventPlayer.DispenserMetal -= 200 - eventPlayer.EngineerMetal
            #Set player metal to max
            eventPlayer.EngineerMetal = 200
            #If player does have room for full tick
        else:
            #Add full tick to engie's metal
            eventPlayer.EngineerMetal += 30 + 10 * eventPlayer.BuildingLevelArray[2]
            #Subtract full tick from Disp metal
            eventPlayer.DispenserMetal -= 30 + 10 * eventPlayer.BuildingLevelArray[2]
    if RULE_CONDITION:
        goto RULE_START


rule "Sentry Turret - Aim when targets are in range":
    @Event eachPlayer
    @Hero bastion
    #There is at least 1 player within 20m of Bastion with LOS (Do not target Cassidy)
    @Condition len([i for i in [player for player in getPlayersInRadius(eventPlayer.getEyePosition(), 20.95, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES) if player.isAlive()] if i.getCurrentHero() != Hero.MCCREE]) > 0
    #Closest Player to Bastion (with LOS) is not already the SentryTarget (Do not target Cassidy)
    @Condition (sorted([i for i in [player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.getCurrentHero() != Hero.MCCREE] if isInLoS(eventPlayer.getEyePosition(), i.getEyePosition(), BarrierLos.PASS_THROUGH_BARRIERS)], lambda i: distance(eventPlayer.getEyePosition(), i.getEyePosition())))[0] != eventPlayer.SentryTarget
    #Not Frozen or Stunned
    @Condition eventPlayer.hasStatusEffect(Status.FROZEN) == false
    @Condition eventPlayer.hasStatusEffect(Status.STUNNED) == false
    #@Condition eventPlayer.BotOwner.SentryCompletion == 100
    @Condition eventPlayer.BotOwner.SentryCompletion == 100
    
    eventPlayer.stopFacing()
    #eventPlayer.SentryTarget = sorted([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer.getEyePosition(), player.getEyePosition(), BarrierLos.PASS_THROUGH_BARRIERS)], lambda i: distance(eventPlayer.getEyePosition(), i.getEyePosition()))[0]
    eventPlayer.SentryTarget = (sorted([i for i in [player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.getCurrentHero() != Hero.MCCREE] if isInLoS(eventPlayer.getEyePosition(), i.getEyePosition(), BarrierLos.PASS_THROUGH_BARRIERS)], lambda i: distance(eventPlayer.getEyePosition(), i.getEyePosition())))[0]
    eventPlayer.startFacing(vectorTowards(eventPlayer.getEyePosition(), eventPlayer.SentryTarget.getEyePosition()), 210, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    #A = sorted([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer.getEyePosition(), player.getEyePosition(), BarrierLos.PASS_THROUGH_BARRIERS)], lambda i: distance(eventPlayer.getEyePosition(), i.getEyePosition()))
    #A = sorted([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer.getEyePosition(), player.getEyePosition(), BarrierLos.PASS_THROUGH_BARRIERS)], lambda i: distance(eventPlayer.getEyePosition(), i.getEyePosition()))


rule "Sentry Turret - Fire guns when target in crosshairs":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.SentryTarget != null
    @Condition eventPlayer.hasStatusEffect(Status.FROZEN) == false
    @Condition eventPlayer.hasStatusEffect(Status.STUNNED) == false
    #If target is within 3 degrees of center of view
    #@Condition eventPlayer.isInViewAngle(eventPlayer.SentryTarget.getEyePosition(), 10) == true
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.SentryTarget.getEyePosition())) <= 1
    @Condition eventPlayer.BotOwner.SentryCompletion == true
    
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    #If level 3
    #if getPlayersOnHero(Hero.TORBJORN, eventPlayer.getTeam()).BuildingLevelArray[1] == 3:
    #eventPlayer.Bot2.stopFacing()
    #eventPlayer.Bot2.setFacing(directionTowards(eventPlayer.Bot2.getEyePosition(), eventPlayer.SentryTarget.getEyePosition()), Relativity.TO_WORLD)
    #wait()
    #Fire Rockets
    #eventPlayer.Bot2.forceButtonPress(Button.SECONDARY_FIRE)
    #__end__()


rule "Sentry Turret - Lv3 Fire rockets":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.SentryTarget != null
    @Condition eventPlayer.hasStatusEffect(Status.FROZEN) == false
    @Condition eventPlayer.hasStatusEffect(Status.STUNNED) == false
    #If target is within 3 degrees of center of view
    #@Condition eventPlayer.isInViewAngle(eventPlayer.SentryTarget.getEyePosition(), 10) == true
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.SentryTarget.getEyePosition())) <= 1
    #Sentry is lv3
    @Condition getPlayersOnHero(Hero.TORBJORN, eventPlayer.getTeam()).BuildingLevelArray[1] == 3
    @Condition eventPlayer.SentryRocketCooldown == 0
    
    eventPlayer.Bot2.stopFacing()
    eventPlayer.Bot2.setFacing(directionTowards(eventPlayer.Bot2.getEyePosition(), eventPlayer.SentryTarget.getEyePosition()), Relativity.TO_WORLD)
    wait()
    #Fire Rockets
    eventPlayer.Bot2.forceButtonPress(Button.SECONDARY_FIRE)
    eventPlayer.SentryRocketCooldown = 3.06
    chase(eventPlayer.SentryRocketCooldown, 0, rate=1, ChaseReeval.NONE)


rule "Sentry Turret - Stop firing when target not in crosshairs":
    @Event eachPlayer
    @Hero bastion
    #If target is within 3 degrees of center of view
    #@Condition eventPlayer.isInViewAngle(eventPlayer.SentryTarget.getEyePosition(), 10) == false
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.SentryTarget.getEyePosition())) > 1
    
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


rule "Sentry Turret - Return to default facing":
    @Event eachPlayer
    @Hero bastion
    #If frozen, stunned, or no targets in range (Ignoring Cassidy)
    @Condition (eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.hasStatusEffect(Status.STUNNED) or len([i for i in [player for player in getPlayersInRadius(eventPlayer.getEyePosition(), 20.95, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES) if player.isAlive()] if i.getCurrentHero() != Hero.MCCREE]) == 0) == true
    #If frozen, stunned, or no targets in range
    #@Condition (eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.hasStatusEffect(Status.STUNNED) or len([i for i in [player for player in getPlayersInRadius(eventPlayer.getEyePosition(), 20.95, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES) if player.isAlive()] if isInLoS(eventPlayer.getEyePosition(), i, BarrierLos.PASS_THROUGH_BARRIERS)]) == 0) == true
    @Condition eventPlayer.BotOwner.SentryCompletion == 100
    
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.stopFacing()
    eventPlayer.startFacing(eventPlayer.BotOwner.BastionDefaultFacing, 100, Relativity.TO_WORLD, FacingReeval.NONE)
    eventPlayer.SentryTarget = null


rule "Teleporter - teleport player standing on entrance":
    @Event eachPlayer
    @Hero torbjorn
    @Condition len(getPlayersInRadius(eventPlayer.BuildingLocationsArray[3], 0.5, eventPlayer.getTeam(), LosCheck.OFF)) > 0
    @Condition eventPlayer.TeleporterCharge == 100
    @Condition getClosestPlayer(eventPlayer.BuildingLocationsArray[3], eventPlayer.getTeam()).getThrottle() == vect(0, 0, 0)
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.PlayerTeleported = getClosestPlayer(eventPlayer.BuildingLocationsArray[3], eventPlayer.getTeam())
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.BLUE, eventPlayer.BuildingLocationsArray[3], 1.3)
    playEffect(getAllPlayers(), DynamicEffect.MOIRA_FADE_DISAPPEAR_SOUND, Color.WHITE, eventPlayer.BuildingLocationsArray[3], 100)
    getClosestPlayer(eventPlayer.BuildingLocationsArray[3], eventPlayer.getTeam()).teleport(eventPlayer.BuildingLocationsArray[4])
    eventPlayer.setFacing(eventPlayer.TPExitFacing, Relativity.TO_WORLD)
    playEffect(getAllPlayers(), DynamicEffect.MOIRA_FADE_REAPPEAR_SOUND, Color.WHITE, eventPlayer.BuildingLocationsArray[4], 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.BLUE, eventPlayer.BuildingLocationsArray[4], 1.3)
    eventPlayer.TeleporterCharge = 0
    eventPlayer.TPUses += 1
    eventPlayer.TPColor = Color.YELLOW


/*
rule "Press Shift to return to weapons":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    #Set BuildableEquipped to Wrench (0)
    eventPlayer.BuildingEquipped = 0
    #Swap HUD text to "Sentry Turret"
    destroyHudText(eventPlayer.EquippedWeaponHUDText[0])
    hudHeader(eventPlayer, "Weapons", HudPosition.TOP, 1, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.EquippedWeaponHUDText[0] = getLastCreatedText()
    #Hide ghost building
    destroyEffect(eventPlayer.BuildingArray[0])
    #Hide ghost range indicator
    destroyEffect(eventPlayer.BuildingArray[5])
    #Re-enable weapons
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
*/

rule "Restock Metal in Spawn Room":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isInSpawnRoom() == true
    
    eventPlayer.EngineerMetal = 200


rule "Teleporter - Ready (Turn Green)":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.TeleporterCharge == 100
    
    eventPlayer.TPColor = Color.GREEN


rule "Spawn metal pickup on death":
    @Event playerDied
    @Condition teamHasHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())) == true
    
    #Changed this to EvaluateOnce
    #getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).MetalSpawnLocations.append(eventPlayer.getPosition())
    #Add dead player location to MetalSpawnLocations array
    getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).MetalSpawnLocations.append(evalOnce(nearestWalkablePosition(eventPlayer.getPosition())))
    #Create Metal Text
    createInWorldText(getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())), "100 Metal", getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).MetalSpawnLocations.last(), 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.GRAY, SpecVisibility.DEFAULT)
    #Create orb at dead player location
    createEffect(getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())), Effect.ORB, Color.GRAY, getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).MetalSpawnLocations.last(), 1, EffectReeval.NONE)
    #Save orb to MetalSpawnEffects array
    getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).MetalSpawnEffects.append(getLastCreatedEntity())
    #Reset and count time since last Metal Spawn
    getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).MetalSpawnTimers = 0
    chase(getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).MetalSpawnTimers, 30, rate=1, ChaseReeval.NONE)


rule "Pick up metal when close":
    @Event eachPlayer
    @Hero torbjorn
    @Condition len([player for player in eventPlayer.MetalSpawnLocations if distance(player, eventPlayer.getPosition()) <= 1]) >= 1
    @Condition eventPlayer.EngineerMetal < 200
    @Condition eventPlayer.MetalSpawnLocations != null
    
    eventPlayer.Index = eventPlayer.MetalSpawnLocations.index(([player for player in eventPlayer.MetalSpawnLocations if distance(eventPlayer, player) <= 1])[0])
    destroyEffect(eventPlayer.MetalSpawnEffects[eventPlayer.Index])
    del eventPlayer.MetalSpawnLocations[eventPlayer.Index]
    del eventPlayer.MetalSpawnEffects[eventPlayer.Index]
    if eventPlayer.EngineerMetal >= 100:
        eventPlayer.EngineerMetal = 200
    else:
        eventPlayer.EngineerMetal += 100
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    if RULE_CONDITION:
        goto RULE_START


rule "Destroy metal pickup after 30s":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.MetalSpawnTimers >= 15
    
    for eventPlayer.Index in range(len(eventPlayer.MetalSpawnEffects)):
        destroyEffect(eventPlayer.MetalSpawnEffects[eventPlayer.Index])
    eventPlayer.MetalSpawnLocations = []
    eventPlayer.MetalSpawnEffects = []


rule "Attack Dispenser by looking at it":
    @Event eachPlayer
    @Condition eventPlayer.isInViewAngle(getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).BuildingLocationsArray[2] + Vector.DOWN, 5) == true
    @Condition isInLoS(eventPlayer.getEyePosition(), getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).BuildingLocationsArray[2] + vect(0, 0, 0), BarrierLos.PASS_THROUGH_BARRIERS) == true
    @Condition eventPlayer.BuildingAttackBeam == null
    @Condition eventPlayer.Invisible == false
    @Condition eventPlayer.isAlive() == true
    
    createBeam(getAllPlayers(), Beam.BAD, eventPlayer, getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).BuildingLocationsArray[2], Color.RED, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.BuildingAttackBeam[0] = getLastCreatedEntity()
    createProgressBarInWorldText(eventPlayer, getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).DispenserHP, "Enemy Dispenser HP", getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).BuildingLocationsArray[2] + vect(0, 0.75, 0), 1, Clip.NONE, Color.RED, Color.RED, ProgressWorldTextReeval.VALUES, SpecVisibility.DEFAULT)
    eventPlayer.BuildingAttackBeam[1] = getLastCreatedText()
    chase(getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).DispenserHP, 0, rate=43 - distance(eventPlayer.getEyePosition(), getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).BuildingLocationsArray[2]), ChaseReeval.DESTINATION_AND_RATE)
    #chase(getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).DispenserHP, 0, rate=50, ChaseReeval.NONE)
    waitUntil(not eventPlayer.isInViewAngle(getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).BuildingLocationsArray[2] + Vector.DOWN, 5) or not isInLoS(eventPlayer.getEyePosition(), getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).BuildingLocationsArray[2], BarrierLos.PASS_THROUGH_BARRIERS) or eventPlayer.isDead(), 99999)
    destroyEffect(eventPlayer.BuildingAttackBeam[0])
    destroyProgressBarInWorldText(eventPlayer.BuildingAttackBeam[1])
    stopChasingVariable(getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).DispenserHP)
    eventPlayer.BuildingAttackBeam = null
    #If dispenser isn't completely built nor destroyed
    if getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).DispenserCompletion != 100 and getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).DispenserCompletion != 0:
        #Continue construction heal over time
        chase(getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).DispenserHP, 100, rate=4.714, ChaseReeval.NONE)


rule "Sentry runs out of HP":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.Bot1.isDead() == true
    
    DestroySentry()


rule "Dispenser runs out of HP":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.DispenserHP <= 0
    
    DestroyDispenser()


rule "TPEntrance runs out of HP":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.TPEntranceHP <= 0
    
    DestroyTPEntrance()


rule "TPExit runs out of HP":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.TPExitHP <= 0
    
    DestroyTPExit()


def DestroySentry():
    @Name "Destroy Sentry (Subroutine)"
    
    #Play sound
    playEffect(getAllPlayers(), DynamicEffect.JUNKRAT_RIP_TIRE_EXPLOSION_SOUND, Color.WHITE, eventPlayer.BuildingLocationsArray[1], 100)
    destroyInWorldText(eventPlayer.SentryText[0])
    destroyInWorldText(eventPlayer.SentryText[1])
    destroyProgressBarHud(eventPlayer.SentryText[5])
    eventPlayer.SentryCompletion = null
    eventPlayer.UpgradeProgressArray[1] = null
    eventPlayer.BuildingLevelArray[1] = null
    eventPlayer.BuildingLocationsArray[1] = null
    if eventPlayer.Bot1 != null:
        destroyDummy(eventPlayer.getTeam(), eventPlayer.Bot1.getSlot())
        eventPlayer.Bot1 = null
    if eventPlayer.Bot2 != null:
        destroyDummy(eventPlayer.getTeam(), eventPlayer.Bot2.getSlot())
        eventPlayer.Bot2 = null


def DestroyDispenser():
    @Name "Destroy Dispenser (subroutine)"
    
    #Play sound
    playEffect(getAllPlayers(), DynamicEffect.JUNKRAT_RIP_TIRE_EXPLOSION_SOUND, Color.WHITE, eventPlayer.BuildingLocationsArray[2], 100)
    #Clear beams/healing over time
    #for eventPlayer.Index in range(len(getPlayers(eventPlayer.getTeam())) - 1):
    #stopHoT(getPlayersInSlot(eventPlayer.Index, eventPlayer.getTeam()).DispenserHealOverTime)
    #destroyEffect(getPlayersInSlot(eventPlayer.Index, eventPlayer.getTeam()).DispenserBeamEffect)
    #Reset all variable arrays
    #getPlayersInSlot(eventPlayer.Index, eventPlayer.getTeam()).DispenserBeamEffect = null
    #getPlayersInSlot(eventPlayer.Index, eventPlayer.getTeam()).DispenserHealOverTime = null
    #__end__()
    #Destroy Dispenser Effect
    destroyEffect(eventPlayer.BuildingArray[2])
    eventPlayer.DispenserCompletion = 0
    destroyProgressBarHud(eventPlayer.DispenserText[5])
    destroyInWorldText(eventPlayer.DispenserText[0])
    destroyInWorldText(eventPlayer.DispenserText[1])
    destroyInWorldText(eventPlayer.DispenserText[2])
    destroyInWorldText(eventPlayer.DispenserText[3])
    destroyInWorldText(eventPlayer.DispenserText[4])
    eventPlayer.BuildingLevelArray[2] = null
    eventPlayer.UpgradeProgressArray[2] = 0
    eventPlayer.BuildingLocationsArray[2] = null
    eventPlayer.DispenserHP = 0


def DestroyTPEntrance():
    @Name "Destroy TPEntrance (subroutine)"
    
    #Destroy Dispenser Sphere
    destroyEffect(eventPlayer.BuildingArray[3])
    #Destroy HUD Metal readout and floating world text
    destroyProgressBarHud(eventPlayer.TPEntranceText[5])
    destroyInWorldText(eventPlayer.TPEntranceText[0])
    destroyInWorldText(eventPlayer.TPEntranceText[1])
    destroyInWorldText(eventPlayer.TPEntranceText[2])
    #Clear "Charge" text from exit
    destroyInWorldText(eventPlayer.TPExitText[2])
    #Reset values for upgrade progress and build completion
    eventPlayer.TPEntranceCompletion = 0
    eventPlayer.UpgradeProgressArray[0] = 0
    eventPlayer.BuildingLocationsArray[3] = null
    eventPlayer.BuildingLevelArray[3] = 1
    eventPlayer.BuildingArray[3] = null
    stopChasingVariable(eventPlayer.TeleporterCharge)
    eventPlayer.TeleporterCharge = null
    eventPlayer.TPEntranceText = null
    eventPlayer.TPEntranceHP = 0.1
    eventPlayer.TPUses = 0
    if eventPlayer.TPExitCompletion == 100:
        destroyInWorldText(eventPlayer.TPExitText[1])
        createInWorldText(getPlayersInRadius(eventPlayer.BuildingLocationsArray[4], 6, eventPlayer.getTeam(), LosCheck.OFF), "Upgrade: {0} / 200".format(eventPlayer.UpgradeProgressArray[3]), vect(eventPlayer.BuildingLocationsArray[4].x, 0.35 + eventPlayer.BuildingLocationsArray[4].y, eventPlayer.BuildingLocationsArray[4].z), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
        eventPlayer.TPExitText[1] = getLastCreatedText()


def DestroyTPExit():
    @Name "Destroy TPExit (subroutine)"
    
    #Destroy Dispenser Sphere
    destroyEffect(eventPlayer.BuildingArray[4])
    #Destroy HUD Metal readout and floating world text
    destroyProgressBarHud(eventPlayer.TPExitText[5])
    destroyInWorldText(eventPlayer.TPExitText[0])
    destroyInWorldText(eventPlayer.TPExitText[1])
    destroyInWorldText(eventPlayer.TPExitText[2])
    #Clear "charge" text from entrance
    destroyInWorldText(eventPlayer.TPEntranceText[2])
    #Reset values for upgrade progress and build completion
    eventPlayer.TPExitCompletion = 0
    eventPlayer.UpgradeProgressArray[3] = null
    eventPlayer.BuildingLocationsArray[4] = null
    eventPlayer.BuildingLevelArray[3] = 1
    eventPlayer.BuildingArray[4] = null
    stopChasingVariable(eventPlayer.TeleporterCharge)
    eventPlayer.TeleporterCharge = null
    eventPlayer.TPExitText = null
    eventPlayer.TPExitHP = 0.1
    eventPlayer.TPUses = 0


def InitializeSentry():
    @Name "InitializeSentry (subroutine)"
    
    if eventPlayer.BuildingRotation == iconString(Icon.ARROW_UP):
        eventPlayer.BastionDefaultFacing = worldVector(vect(0, 0, 1), eventPlayer, Transform.ROTATION)
    elif eventPlayer.BuildingRotation == iconString(Icon.ARROW_RIGHT):
        eventPlayer.BastionDefaultFacing = worldVector(vect(-1, 0, 0), eventPlayer, Transform.ROTATION)
    elif eventPlayer.BuildingRotation == iconString(Icon.ARROW_DOWN):
        eventPlayer.BastionDefaultFacing = worldVector(vect(0, 0, -1), eventPlayer, Transform.ROTATION)
    elif eventPlayer.BuildingRotation == iconString(Icon.ARROW_LEFT):
        eventPlayer.BastionDefaultFacing = worldVector(vect(1, 0, 0), eventPlayer, Transform.ROTATION)
    #Sentry Level = 1
    eventPlayer.BuildingLevelArray[1] = 1
    #Set upgrade progress to 0
    eventPlayer.UpgradeProgressArray[1] = 0
    createDummy(Hero.BASTION, eventPlayer.getTeam(), -1, eventPlayer + eventPlayer.getFacingDirection() * vect(2, 0, 2) + vect(0, 0, 0), eventPlayer.BastionDefaultFacing)
    eventPlayer.Bot1 = getLastCreatedEntity()
    wait()
    eventPlayer.Bot1.BotOwner = eventPlayer
    eventPlayer.Bot1.startScalingSize(0.5, false)
    eventPlayer.Bot1.startForcingName("{0}'s Sentry".format(eventPlayer))
    getPlayersOnHero(Hero.BASTION, eventPlayer.getTeam()).removeAllHealthPools()
    #Set Lastconstruction to 1 (Sentry)
    eventPlayer.LastConstruction = 1
    #Setup Progress Meter with 10.5s build time
    eventPlayer.SentryCompletion = 0
    chase(eventPlayer.SentryCompletion, 100, rate=9.524, ChaseReeval.NONE)
    wait(0.5)
    eventPlayer.Bot1.addHealthPool(Health.NORMAL, eventPlayer.SentryCompletion * 1.47, true, true)
    getPlayersOnHero(Hero.BASTION, eventPlayer.getTeam()).startHoT(null, 9999, 15)
    progressBarHud(eventPlayer, getPlayersOnHero(Hero.BASTION, eventPlayer.getTeam()).getHealth() / 1.5, "Lv1 Sentry HP: {0}".format(ceil(getPlayersOnHero(Hero.BASTION, eventPlayer.getTeam()).getHealth())), HudPosition.RIGHT, 0, Color.WHITE, Color.WHITE, ProgressHudReeval.VALUES, SpecVisibility.DEFAULT)
    eventPlayer.SentryText[5] = getLastCreatedText()
    #Add location to buildingLocationsArray
    eventPlayer.BuildingLocationsArray[1] = eventPlayer.Bot1.getEyePosition()
    #Add world text
    createInWorldText(getPlayersInRadius(eventPlayer.BuildingLocationsArray[1], 6, eventPlayer.getTeam(), LosCheck.OFF), "{0}'s Lv{1} Sentry".format(eventPlayer, eventPlayer.BuildingLevelArray[1]), eventPlayer.BuildingLocationsArray[1] + vect(0, -0.4, 0), 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.SentryText[0] = getLastCreatedText()
    createInWorldText(getPlayersInRadius(eventPlayer.BuildingLocationsArray[1], 6, eventPlayer.getTeam(), LosCheck.OFF), "Building: {0}%".format(eventPlayer.SentryCompletion), vect(eventPlayer.BuildingLocationsArray[1].x, -0.49 + eventPlayer.BuildingLocationsArray[1].y, eventPlayer.BuildingLocationsArray[1].z), 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.SentryText[1] = getLastCreatedText()
    eventPlayer.Bot1.setAbility1Enabled(true)
    eventPlayer.Bot1.forceButtonPress(Button.ABILITY_1)
    #Wait for transformation to complete
    wait(1)
    eventPlayer.Bot1.setStatusEffect(null, Status.FROZEN, 10.5)
    eventPlayer.Bot1 = getPlayersOnHero(Hero.BASTION, eventPlayer.getTeam())


def InitializeDispenser():
    @Name "Initialize Dispenser (Subroutine)"
    
    #Dispenser Level = 1
    eventPlayer.BuildingLevelArray[2] = 1
    #Set upgrade progress to 0
    eventPlayer.UpgradeProgressArray[2] = 0
    eventPlayer.BuildingLocationsArray[2] = raycast(eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2, eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2 + vect(0, -3, 0), getAllPlayers(), eventPlayer, true).getHitPosition() + vect(0, 0.55, 0)
    createEffect(getAllPlayers(), Effect.SPHERE, eventPlayer.getTeam(), eventPlayer.BuildingLocationsArray[2], 0.55, EffectReeval.COLOR)
    eventPlayer.BuildingArray[2] = getLastCreatedEntity()
    #Set Lastconstruction to 2 (Dispenser)
    eventPlayer.LastConstruction = 2
    #Setup Progress Meter with 10s build time
    eventPlayer.DispenserCompletion = 0
    chase(eventPlayer.DispenserCompletion, 100, rate=4.762, ChaseReeval.NONE)
    createInWorldText(getPlayersInRadius(eventPlayer.BuildingLocationsArray[2], 6, eventPlayer.getTeam(), LosCheck.OFF), "{0}'s Lv{1} Dispenser".format(eventPlayer, eventPlayer.BuildingLevelArray[2]), eventPlayer.BuildingLocationsArray[2] + vect(0, 0.3, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.DispenserText[0] = getLastCreatedText()
    createInWorldText(getPlayersInRadius(eventPlayer.BuildingLocationsArray[2], 6, eventPlayer.getTeam(), LosCheck.OFF), "Building: {0}%".format(eventPlayer.DispenserCompletion), eventPlayer.BuildingLocationsArray[2] + vect(0, 0.2, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.DispenserText[1] = getLastCreatedText()
    #Setup HP
    eventPlayer.DispenserHP = 1
    chase(eventPlayer.DispenserHP, 100, rate=4.714, ChaseReeval.NONE)
    progressBarHud(eventPlayer, eventPlayer.DispenserHP, "Dispenser HP: {0}%  |  Metal: {1} / 400".format(ceil(eventPlayer.DispenserHP), eventPlayer.DispenserMetal), HudPosition.RIGHT, 0.2, Color.WHITE, Color.WHITE, ProgressHudReeval.VALUES, SpecVisibility.DEFAULT)
    eventPlayer.DispenserText[5] = getLastCreatedText()
    createInWorldText(getPlayersInRadius(eventPlayer.BuildingLocationsArray[2], 12, eventPlayer.getTeam(), LosCheck.OFF), iconString(Icon.ARROW_DOWN), eventPlayer.BuildingLocationsArray[2] + vect(0, 0, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.DispenserText[2] = getLastCreatedText()


def InitializeTPEntrance():
    @Name "Initialize TP Entrance (Subroutine)"
    
    #If exit is not built
    if eventPlayer.TPExitCompletion != 100:
        #TP Level = 1
        eventPlayer.BuildingLevelArray[3] = 1
        #Set upgrade progress to 0
        eventPlayer.UpgradeProgressArray[3] = 0
    eventPlayer.BuildingLocationsArray[3] = raycast(eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2, eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2 + vect(0, -3, 0), getAllPlayers(), eventPlayer, true).getHitPosition() + vect(0, 0.05, 0)
    eventPlayer.TPColor = Color.RED
    createEffect(getAllPlayers(), Effect.RING, eventPlayer.TPColor, eventPlayer.BuildingLocationsArray[3], 0.55, EffectReeval.COLOR)
    eventPlayer.BuildingArray[3] = getLastCreatedEntity()
    #Set Lastconstruction to 3 (TPEntrance)
    eventPlayer.LastConstruction = 3
    #Setup Progress Meter with 10s build time
    eventPlayer.TPEntranceCompletion = 0
    chase(eventPlayer.TPEntranceCompletion, 100, rate=4.762, ChaseReeval.NONE)
    createInWorldText(getPlayersInRadius(eventPlayer.BuildingLocationsArray[3], 6, eventPlayer.getTeam(), LosCheck.OFF), "{0}'s Lv{1} Teleporter Entrance".format(eventPlayer, eventPlayer.BuildingLevelArray[3]), eventPlayer.BuildingLocationsArray[3] + vect(0, 0.3, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.TPEntranceText[0] = getLastCreatedText()
    createInWorldText(getPlayersInRadius(eventPlayer.BuildingLocationsArray[3], 6, eventPlayer.getTeam(), LosCheck.OFF), "Building: {0}%".format(eventPlayer.TPEntranceCompletion), eventPlayer.BuildingLocationsArray[3] + vect(0, 0.2, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.TPEntranceText[1] = getLastCreatedText()
    #Setup HP
    eventPlayer.TPEntranceHP = 1
    chase(eventPlayer.TPEntranceHP, 100, rate=4.714, ChaseReeval.NONE)
    progressBarHud(eventPlayer, eventPlayer.TPEntranceHP, "Teleporter Entrance HP: {0}%  |  Charge: {1}%".format(ceil(eventPlayer.TPEntranceHP), ceil(eventPlayer.TeleporterCharge)), HudPosition.RIGHT, 0.2, Color.WHITE, Color.WHITE, ProgressHudReeval.VALUES, SpecVisibility.DEFAULT)
    eventPlayer.TPEntranceText[5] = getLastCreatedText()
    createInWorldText(getPlayersInRadius(eventPlayer.BuildingLocationsArray[3], 12, eventPlayer.getTeam(), LosCheck.OFF), iconString(Icon.ARROW_DOWN), eventPlayer.BuildingLocationsArray[3] + vect(0, 0, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.TPEntranceText[3] = getLastCreatedText()


def InitializeTPExit():
    @Name "Initialize TP Exit (Subroutine)"
    
    #If entrance is not built
    if eventPlayer.TPEntranceCompletion != 100:
        #TP Level = 1
        eventPlayer.BuildingLevelArray[3] = 1
        #Set upgrade progress to 0
        eventPlayer.UpgradeProgressArray[3] = 0
    eventPlayer.BuildingLocationsArray[4] = raycast(eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2, eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 2 + vect(0, -3, 0), getAllPlayers(), eventPlayer, true).getHitPosition() + vect(0, 0.05, 0)
    eventPlayer.TPColor = Color.RED
    createEffect(getAllPlayers(), Effect.RING, eventPlayer.TPColor, eventPlayer.BuildingLocationsArray[4], 0.55, EffectReeval.COLOR)
    eventPlayer.BuildingArray[4] = getLastCreatedEntity()
    #Set Lastconstruction to 3 (TPExit)
    eventPlayer.LastConstruction = 3
    #Setup Progress Meter with 10s build time
    eventPlayer.TPExitCompletion = 0
    chase(eventPlayer.TPExitCompletion, 100, rate=4.762, ChaseReeval.NONE)
    createInWorldText(getPlayersInRadius(eventPlayer.BuildingLocationsArray[4], 6, eventPlayer.getTeam(), LosCheck.OFF), "{0}'s Lv{1} Teleporter Exit".format(eventPlayer, eventPlayer.BuildingLevelArray[3]), eventPlayer.BuildingLocationsArray[4] + vect(0, 0.3, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.TPExitText[0] = getLastCreatedText()
    createInWorldText(getPlayersInRadius(eventPlayer.BuildingLocationsArray[4], 6, eventPlayer.getTeam(), LosCheck.OFF), "Building: {0}%".format(eventPlayer.TPExitCompletion), eventPlayer.BuildingLocationsArray[4] + vect(0, 0.2, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.TPExitText[1] = getLastCreatedText()
    #Setup HP
    eventPlayer.TPExitHP = 1
    chase(eventPlayer.TPExitHP, 100, rate=4.714, ChaseReeval.NONE)
    progressBarHud(eventPlayer, eventPlayer.TPExitHP, "Teleporter Exit HP: {0}%  |  Charge: {1}%".format(ceil(eventPlayer.TPExitHP), ceil(eventPlayer.TeleporterCharge)), HudPosition.RIGHT, 0.2, Color.WHITE, Color.WHITE, ProgressHudReeval.VALUES, SpecVisibility.DEFAULT)
    eventPlayer.TPExitText[5] = getLastCreatedText()
    createInWorldText(getPlayersInRadius(eventPlayer.BuildingLocationsArray[4], 12, eventPlayer.getTeam(), LosCheck.OFF), iconString(Icon.ARROW_UP), eventPlayer.BuildingLocationsArray[4] + vect(0, 0, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.TPExitText[3] = getLastCreatedText()
    if eventPlayer.BuildingRotation == iconString(Icon.ARROW_UP):
        eventPlayer.TPExitFacing = worldVector(vect(0, 0, 1), eventPlayer, Transform.ROTATION)
    elif eventPlayer.BuildingRotation == iconString(Icon.ARROW_RIGHT):
        eventPlayer.TPExitFacing = worldVector(vect(-1, 0, 0), eventPlayer, Transform.ROTATION)
    elif eventPlayer.BuildingRotation == iconString(Icon.ARROW_DOWN):
        eventPlayer.TPExitFacing = worldVector(vect(0, 0, -1), eventPlayer, Transform.ROTATION)
    elif eventPlayer.BuildingRotation == iconString(Icon.ARROW_LEFT):
        eventPlayer.TPExitFacing = worldVector(vect(1, 0, 0), eventPlayer, Transform.ROTATION)


rule "Sentry - Melee to Speed Up Build / Heal / Upgrade":
    @Event eachPlayer
    @Hero torbjorn
    #Sentry Exists
    @Condition eventPlayer.BuildingLocationsArray[1] != 0
    #is in front of you
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.Bot1.getEyePosition())) <= 40
    #is close to you
    @Condition distance(eventPlayer.getPosition(), getPlayersOnHero(Hero.BASTION, eventPlayer.getTeam()).getEyePosition()) <= 4
    #Wrench equipped
    #@Condition eventPlayer.getCurrentWeapon() == 2
    #You are swinging wrench
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    #wait for wrench impact
    wait(0.35)
    if eventPlayer.EngineerMetal == 0:
        if eventPlayer.SentryCompletion < 100:
            playEffect(eventPlayer, DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
            eventPlayer.SentryCompletion += 7.5
            heal(eventPlayer.Bot1, null, 11)
            if eventPlayer.SentryCompletion > 100:
                eventPlayer.SentryCompletion = 100
        else:
            bigMessage(eventPlayer, "No metal!")
            playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 50)
        #If Engie has metal
    else:
        #If it needs healed
        if eventPlayer.SentryCompletion == 100 and eventPlayer.Bot1.getNormalizedHealth() != 1:
            #Play sound
            playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
            #If in needs healed by 100 or more
            if eventPlayer.Bot1.getMaxHealth() - eventPlayer.Bot1.getHealth() >= 100:
                #If you have 33 metal, heal 100
                if eventPlayer.EngineerMetal >= 33:
                    eventPlayer.EngineerMetal -= 33
                    heal(eventPlayer.Bot1, eventPlayer, 100)
                    #if not, heal as much as you can
                else:
                    heal(eventPlayer.Bot1, eventPlayer, eventPlayer.EngineerMetal * 3)
                    eventPlayer.EngineerMetal = 0
                #if it doesn't need healed the full 100, check if you have enough metal for necessary heal
            elif eventPlayer.EngineerMetal < (eventPlayer.Bot1.getMaxHealth() - eventPlayer.Bot1.getHealth()) / 3:
                #if you don't have enough metal, heal metal*3
                heal(eventPlayer.Bot1, eventPlayer, eventPlayer.EngineerMetal * 3)
                eventPlayer.EngineerMetal = 0
                #if you have enough metal for full heal
            else:
                eventPlayer.EngineerMetal -= (eventPlayer.Bot1.getMaxHealth() - eventPlayer.Bot1.getHealth()) / 3
                heal(eventPlayer.Bot1, eventPlayer, 100)
            #If it doesn't need healed
        else:
            #If it's complete, try to upgrade
            if eventPlayer.SentryCompletion == 100:
                #If it's not already level 3
                if eventPlayer.BuildingLevelArray[1] < 3:
                    #If you have enough metal, upgrade
                    if eventPlayer.EngineerMetal >= 25:
                        playEffect(eventPlayer, DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT_SOUND, Color.WHITE, eventPlayer, 50)
                        eventPlayer.EngineerMetal -= 25
                        eventPlayer.UpgradeProgressArray[1] += 25
                        #If upgradeprogress = 200, advance 1 level and reset upgradeprogress to 0
                        if eventPlayer.UpgradeProgressArray[1] >= 200:
                            eventPlayer.BuildingLevelArray[1] += 1
                            #If level is max, destroy upgrade progress in-world text
                            if eventPlayer.BuildingLevelArray[1] == 3:
                                destroyInWorldText(eventPlayer.SentryText[1])
                                eventPlayer.Bot1.startScalingSize(1.2, false)
                                eventPlayer.Bot1.addHealthPool(Health.NORMAL, 36, true, false)
                                heal(eventPlayer.Bot1, null, 36)
                                #Added rockets, no longer need lv3 damage scaling
                                #eventPlayer.Bot1.setDamageDealt(232)
                            else:
                                eventPlayer.Bot1.addHealthPool(Health.NORMAL, 30, true, false)
                                eventPlayer.Bot1.startScalingSize(0.8, false)
                                heal(eventPlayer.Bot1, null, 30)
                                eventPlayer.Bot1.setDamageDealt(166)
                            eventPlayer.UpgradeProgressArray[1] = 0
                        #If you don't have enough metal, play sound and give HUD notice
                    else:
                        bigMessage(getAllPlayers(), "Not enough metal!")
                        playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
                #If it's incomplete, speed up build time
            else:
                playEffect(eventPlayer, DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT_SOUND, Color.WHITE, eventPlayer, 50)
                eventPlayer.SentryCompletion += 7.5
                heal(eventPlayer.Bot1, null, 11)
                if eventPlayer.SentryCompletion > 100:
                    eventPlayer.SentryCompletion = 100
        wait(0.485)
        if RULE_CONDITION:
            goto RULE_START


rule "Dispenser - Melee to Build > Heal > Upgrade":
    @Event eachPlayer
    @Hero torbjorn
    #Dispenser Exists
    @Condition eventPlayer.BuildingLocationsArray[2] != 0
    #Dispenser is in front of you
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.BuildingLocationsArray[2])) <= 30
    #Dispenser is close to you
    @Condition distance(eventPlayer.getPosition(), eventPlayer.BuildingLocationsArray[2]) <= 2.1
    #Wrench equipped
    #@Condition eventPlayer.getCurrentWeapon() == 2
    #You are swinging wrench
    @Condition eventPlayer.isFiringPrimaryFire() == true
    
    #Building incomplete, advance completion
    if eventPlayer.DispenserCompletion < 100:
        eventPlayer.DispenserCompletion += 5
        eventPlayer.DispenserHP += 5
        if eventPlayer.DispenserCompletion > 100:
            eventPlayer.DispenserCompletion = 100
        else:
            playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    elif eventPlayer.EngineerMetal == 0:
        playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
        bigMessage(eventPlayer, "No metal!")
        #building is complete and not full HP
    elif eventPlayer.DispenserHP < 100:
        #if missing HP is more than we can fix in single swing
        if eventPlayer.DispenserHP < 34:
            #if you have 33 metal to repair max (66)
            if eventPlayer.EngineerMetal >= 33:
                eventPlayer.EngineerMetal -= 33
                eventPlayer.DispenserHP += 66
                playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
                #if not enough metal for full repair
            else:
                eventPlayer.DispenserHP += eventPlayer.EngineerMetal * 2
                eventPlayer.EngineerMetal = 0
                playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
            #if missing HP is less than 66, if you have enough metal for full repair
        elif eventPlayer.EngineerMetal >= eventPlayer.DispenserHP / 2:
            eventPlayer.EngineerMetal -= eventPlayer.DispenserHP / 2
            eventPlayer.DispenserHP = 100
            playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
            #if you don't have enough metal for full repair
        else:
            eventPlayer.DispenserHP += eventPlayer.EngineerMetal * 2
            eventPlayer.EngineerMetal = 0
            playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
        #building is complete and full hp, try upgrading
    elif eventPlayer.BuildingLevelArray[2] < 3:
        #If you have enough metal for 1 upgrade swing
        if eventPlayer.EngineerMetal >= 25:
            eventPlayer.EngineerMetal -= 25
            eventPlayer.UpgradeProgressArray[2] += 25
            #If this swing got upgrade to 200 / 200
            if eventPlayer.UpgradeProgressArray[2] >= 200:
                eventPlayer.BuildingLevelArray[2] += 1
                playEffect(getAllPlayers(), DynamicEffect.SOMBRA_LOGO_SOUND, Color.WHITE, eventPlayer.BuildingLocationsArray[2], 100)
                #If this swing got level to max
                if eventPlayer.BuildingLevelArray[2] == 3:
                    #destroy upgrade progress in-world text
                    destroyInWorldText(eventPlayer.DispenserText[2])
                eventPlayer.UpgradeProgressArray[2] = 0
                #If this swing didn't fully upgrade
            else:
                #play the normal hit sound
                playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
            #not enough metal for full upgrade swing
        else:
            #Play sound and give HUD message
            playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
            bigMessage(eventPlayer, "Not enough metal!")
        #Building is full HP and level 3 (do nothing)
    else:


rule "TPEntrance - Melee to Speed Up Build / Heal / Upgrade":
    @Event eachPlayer
    @Hero torbjorn
    #Exists
    @Condition eventPlayer.BuildingLocationsArray[3] != 0
    #is in front of you
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.BuildingLocationsArray[3])) <= 30
    #is close to you
    @Condition distance(eventPlayer.getPosition(), eventPlayer.BuildingLocationsArray[3]) <= 2
    #Wrench equipped
    #@Condition eventPlayer.getCurrentWeapon() == 2
    #You are swinging wrench
    @Condition eventPlayer.isFiringPrimaryFire() == true
    
    #Building incomplete, advance completion
    if eventPlayer.TPEntranceCompletion < 100:
        eventPlayer.TPEntranceCompletion += 5
        eventPlayer.TPEntranceHP += 5
        if eventPlayer.TPEntranceCompletion > 100:
            eventPlayer.TPEntranceCompletion = 100
        else:
            playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    elif eventPlayer.EngineerMetal == 0:
        playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
        bigMessage(getAllPlayers(), "No metal!")
        #building is complete and not full HP
    elif eventPlayer.TPEntranceHP < 100:
        #if missing HP is more than we can fix in single swing
        if eventPlayer.TPEntranceHP < 34:
            #if you have 33 metal to repair max (66)
            if eventPlayer.EngineerMetal >= 33:
                eventPlayer.EngineerMetal -= 33
                eventPlayer.TPEntranceHP += 66
                playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
                #if not enough metal for full repair
            else:
                eventPlayer.TPEntranceHP += eventPlayer.EngineerMetal * 2
                eventPlayer.EngineerMetal = 0
                playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
            #if missing HP is less than 66, if you have enough metal for full repair
        elif eventPlayer.EngineerMetal >= eventPlayer.TPEntranceHP / 2:
            eventPlayer.EngineerMetal -= eventPlayer.TPEntranceHP / 2
            eventPlayer.TPEntranceHP = 100
            playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
            #if you don't have enough metal for full repair
        else:
            eventPlayer.TPEntranceHP += eventPlayer.EngineerMetal * 2
            eventPlayer.EngineerMetal = 0
            playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
        #if TPExit needs healing, heal it as well
        if eventPlayer.TPExitHP < 100:
            #if missing HP is more than we can fix in single swing
            if eventPlayer.TPExitHP < 34:
                #if you have 33 metal to repair max (66)
                if eventPlayer.EngineerMetal >= 33:
                    eventPlayer.EngineerMetal -= 33
                    eventPlayer.TPExitHP += 66
                    playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
                    #if not enough metal for full repair
                else:
                    eventPlayer.TPExitHP += eventPlayer.EngineerMetal * 2
                    eventPlayer.EngineerMetal = 0
                    playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
                #if missing HP is less than 66, if you have enough metal for full repair
            elif eventPlayer.EngineerMetal >= eventPlayer.TPExitHP / 2:
                eventPlayer.EngineerMetal -= eventPlayer.TPExitHP / 2
                eventPlayer.TPExitHP = 100
                playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
                #if you don't have enough metal for full repair
            else:
                eventPlayer.TPExitHP += eventPlayer.EngineerMetal * 2
                eventPlayer.EngineerMetal = 0
                playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
        #If TPEntrance is full HP, check if TPExit needs healed
    elif eventPlayer.TPExitHP < 100:
        #if missing HP is more than we can fix in single swing
        if eventPlayer.TPExitHP < 34:
            #if you have 33 metal to repair max (66)
            if eventPlayer.EngineerMetal >= 33:
                eventPlayer.EngineerMetal -= 33
                eventPlayer.TPExitHP += 66
                playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
                #if not enough metal for full repair
            else:
                eventPlayer.TPExitHP += eventPlayer.EngineerMetal * 2
                eventPlayer.EngineerMetal = 0
                playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
            #if missing HP is less than 66, if you have enough metal for full repair
        elif eventPlayer.EngineerMetal >= eventPlayer.TPExitHP / 2:
            eventPlayer.EngineerMetal -= eventPlayer.TPExitHP / 2
            eventPlayer.TPExitHP = 100
            playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
            #if you don't have enough metal for full repair
        else:
            eventPlayer.TPExitHP += eventPlayer.EngineerMetal * 2
            eventPlayer.EngineerMetal = 0
            playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
        #building is complete and full hp, try upgrading
    elif eventPlayer.BuildingLevelArray[3] < 3:
        #If you have enough metal for 1 upgrade swing
        if eventPlayer.EngineerMetal >= 25:
            eventPlayer.EngineerMetal -= 25
            eventPlayer.UpgradeProgressArray[3] += 25
            #If this swing got upgrade to 200 / 200
            if eventPlayer.UpgradeProgressArray[3] >= 200:
                eventPlayer.BuildingLevelArray[3] += 1
                playEffect(getAllPlayers(), DynamicEffect.SOMBRA_LOGO_SOUND, Color.WHITE, eventPlayer.BuildingLocationsArray[3], 100)
                #If this swing got level to max
                if eventPlayer.BuildingLevelArray[3] == 3:
                    destroyInWorldText(eventPlayer.TPEntranceText[1])
                    #if linked to exit, destroy upgrade text at exit as well
                    if eventPlayer.TPExitCompletion == 100:
                        #destroy upgrade progress in-world text
                        destroyInWorldText(eventPlayer.TPExitText[1])
                eventPlayer.UpgradeProgressArray[3] = 0
                #If this swing didn't fully upgrade
            else:
                #play the normal hit sound
                playEffect(eventPlayer, DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
            #not enough metal for full upgrade swing
        else:
            #Play sound and give HUD message
            playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
            bigMessage(getAllPlayers(), "Not enough metal!")
        #Building is full HP and level 3
    else:
        #Do nothing
        playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 50)


rule "TPExit - Melee to Speed Up Build / Heal / Upgrade":
    @Event eachPlayer
    @Hero torbjorn
    #Exists
    @Condition eventPlayer.BuildingLocationsArray[4] != 0
    #is in front of you
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.BuildingLocationsArray[4])) <= 30
    #is close to you
    @Condition distance(eventPlayer.getPosition(), eventPlayer.BuildingLocationsArray[4]) <= 2
    #Wrench equipped
    @Condition eventPlayer.getCurrentWeapon() == 2
    #You are swinging wrench
    @Condition eventPlayer.isFiringPrimaryFire() == true
    
    #Building incomplete, advance completion
    if eventPlayer.TPExitCompletion < 100:
        eventPlayer.TPExitCompletion += 5
        eventPlayer.TPExitHP += 5
        if eventPlayer.TPExitCompletion > 100:
            eventPlayer.TPExitCompletion = 100
        else:
            playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    elif eventPlayer.EngineerMetal == 0:
        playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
        bigMessage(getAllPlayers(), "No metal!")
        #building is complete and not full HP
    elif eventPlayer.TPExitHP < 100:
        #if missing HP is more than we can fix in single swing
        if eventPlayer.TPExitHP < 34:
            #if you have 33 metal to repair max (66)
            if eventPlayer.EngineerMetal >= 33:
                eventPlayer.EngineerMetal -= 33
                eventPlayer.TPExitHP += 66
                playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
                #if not enough metal for full repair
            else:
                eventPlayer.TPExitHP += eventPlayer.EngineerMetal * 2
                eventPlayer.EngineerMetal = 0
                playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
            #if missing HP is less than 66, if you have enough metal for full repair
        elif eventPlayer.EngineerMetal >= eventPlayer.TPExitHP / 2:
            eventPlayer.EngineerMetal -= eventPlayer.TPExitHP / 2
            eventPlayer.TPExitHP = 100
            playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
            #if you don't have enough metal for full repair
        else:
            eventPlayer.TPExitHP += eventPlayer.EngineerMetal * 2
            eventPlayer.EngineerMetal = 0
            playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
        #if TPEntrance needs healing, heal it as well
        if eventPlayer.TPEntranceHP < 100:
            #if missing HP is more than we can fix in single swing
            if eventPlayer.TPEntranceHP < 34:
                #if you have 33 metal to repair max (66)
                if eventPlayer.EngineerMetal >= 33:
                    eventPlayer.EngineerMetal -= 33
                    eventPlayer.TPEntranceHP += 66
                    playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
                    #if not enough metal for full repair
                else:
                    eventPlayer.TPEntranceHP += eventPlayer.EngineerMetal * 2
                    eventPlayer.EngineerMetal = 0
                    playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
                #if missing HP is less than 66, if you have enough metal for full repair
            elif eventPlayer.EngineerMetal >= eventPlayer.TPEntranceHP / 2:
                eventPlayer.EngineerMetal -= eventPlayer.TPEntranceHP / 2
                eventPlayer.TPEntranceHP = 100
                playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
                #if you don't have enough metal for full repair
            else:
                eventPlayer.TPEntranceHP += eventPlayer.EngineerMetal * 2
                eventPlayer.EngineerMetal = 0
                playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
        #If TPExit is full HP, check if TPEntrance needs healed
    elif eventPlayer.TPEntranceHP < 100:
        #if missing HP is more than we can fix in single swing
        if eventPlayer.TPEntranceHP < 34:
            #if you have 33 metal to repair max (66)
            if eventPlayer.EngineerMetal >= 33:
                eventPlayer.EngineerMetal -= 33
                eventPlayer.TPEntranceHP += 66
                playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
                #if not enough metal for full repair
            else:
                eventPlayer.TPEntranceHP += eventPlayer.EngineerMetal * 2
                eventPlayer.EngineerMetal = 0
                playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
            #if missing HP is less than 66, if you have enough metal for full repair
        elif eventPlayer.EngineerMetal >= eventPlayer.TPEntranceHP / 2:
            eventPlayer.EngineerMetal -= eventPlayer.TPEntranceHP / 2
            eventPlayer.TPEntranceHP = 100
            playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
            #if you don't have enough metal for full repair
        else:
            eventPlayer.TPExitHP += eventPlayer.EngineerMetal * 2
            eventPlayer.EngineerMetal = 0
            playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
        #building is complete and full hp, try upgrading
    elif eventPlayer.BuildingLevelArray[3] < 3:
        #If you have enough metal for 1 upgrade swing
        if eventPlayer.EngineerMetal >= 25:
            eventPlayer.EngineerMetal -= 25
            eventPlayer.UpgradeProgressArray[3] += 25
            #If this swing got upgrade to 200 / 200
            if eventPlayer.UpgradeProgressArray[3] >= 200:
                eventPlayer.BuildingLevelArray[3] += 1
                playEffect(getAllPlayers(), DynamicEffect.SOMBRA_LOGO_SOUND, Color.WHITE, eventPlayer.BuildingLocationsArray[3], 100)
                #If this swing got level to max
                if eventPlayer.BuildingLevelArray[3] == 3:
                    #destroy upgrade progress in-world text
                    destroyInWorldText(eventPlayer.TPExitText[1])
                    #if linked to entrance, destroy upgrade text at entrance as well
                    if eventPlayer.TPEntranceCompletion == 100:
                        #destroy upgrade progress in-world text
                        destroyInWorldText(eventPlayer.TPEntranceText[1])
                eventPlayer.UpgradeProgressArray[3] = 0
                #If this swing didn't fully upgrade
            else:
                #play the normal hit sound
                playEffect(eventPlayer, DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
            #not enough metal for full upgrade swing
        else:
            #Play sound and give HUD message
            playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
            bigMessage(getAllPlayers(), "Not enough metal!")
        #Building is full HP and level 3
    else:
        #Do nothing
        playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 50)


rule "Finished Building - Sentry":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.SentryCompletion >= 100
    
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_LOGO_SOUND, Color.WHITE, eventPlayer.BuildingLocationsArray[1], 100)
    getPlayersOnHero(Hero.BASTION, eventPlayer.getTeam()).clearStatusEffect(Status.FROZEN)
    getPlayersOnHero(Hero.BASTION, eventPlayer.getTeam()).stopAllHoT()
    destroyInWorldText(eventPlayer.SentryText[1])
    createInWorldText(getPlayersInRadius(eventPlayer.Bot1.getEyePosition(), 6, eventPlayer.getTeam(), LosCheck.OFF), "Upgrade: {0} / 200".format(eventPlayer.UpgradeProgressArray[1]), eventPlayer.BuildingLocationsArray[1] + vect(0, -0.49, 0), 1, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.SentryText[1] = getLastCreatedText()
    if eventPlayer.Bot1.getHealth() >= 140:
        heal(eventPlayer.Bot1, null, 10)
    destroyProgressBarHud(eventPlayer.SentryText[5])
    progressBarHud(eventPlayer, eventPlayer.Bot1.getNormalizedHealth() * 100, "Lv{1} Sentry HP: {0}  |  Kills: {2}".format(ceil(getPlayersOnHero(Hero.BASTION, eventPlayer.getTeam()).getHealth()), eventPlayer.BuildingLevelArray[1], eventPlayer.Bot1.getNumberOfFinalBlows()), HudPosition.RIGHT, 0, Color.WHITE, Color.WHITE, ProgressHudReeval.VALUES, SpecVisibility.DEFAULT)
    eventPlayer.SentryText[5] = getLastCreatedText()


rule "Finished Building - Dispenser":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.DispenserCompletion == 100
    
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_LOGO_SOUND, Color.WHITE, eventPlayer.BuildingLocationsArray[2], 100)
    #Delete "building" text
    destroyInWorldText(eventPlayer.DispenserText[1])
    eventPlayer.DispenserMetal = 25
    #Create HUD Dispenser Metal diplay
    #hudHeader(eventPlayer, "Dispenser Metal: {0} / 400".format(ceil(eventPlayer.DispenserMetal)), HudPosition.RIGHT, 2, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #eventPlayer.DispenserText[5] = getLastCreatedText()
    #Create upgrade progress in-world text
    createInWorldText(getPlayersInRadius(eventPlayer.BuildingLocationsArray[2], 6, eventPlayer.getTeam(), LosCheck.OFF), "Upgrade: {0} / 200".format(eventPlayer.UpgradeProgressArray[2]), eventPlayer.BuildingLocationsArray[2] + vect(0, 0.2, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.DispenserText[2] = getLastCreatedText()
    #Loop metal generation every 5s
    while true:
        wait(5, Wait.ABORT_WHEN_FALSE)
        if eventPlayer.DispenserMetal < 400:
            playEffect(getAllPlayers(), DynamicEffect.TRACER_RECALL_REAPPEAR_SOUND, Color.WHITE, eventPlayer.BuildingLocationsArray[2], 100)
            #Generate 40/50/60 metal every 5s for lv 1/2/3
            eventPlayer.DispenserMetal += 30 + 10 * eventPlayer.BuildingLevelArray[2]
            #Caps at 400 metal
            if eventPlayer.DispenserMetal > 400:
                eventPlayer.DispenserMetal = 400


rule "Finished Building - TP Entrance":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.TPEntranceCompletion == 100
    
    destroyInWorldText(eventPlayer.TPEntranceText[1])
    if eventPlayer.BuildingLevelArray[3] != 3:
        createInWorldText(getPlayersInRadius(eventPlayer.BuildingLocationsArray[3], 6, eventPlayer.getTeam(), LosCheck.OFF), "Upgrade: {0} / 200".format(eventPlayer.UpgradeProgressArray[3]), eventPlayer.BuildingLocationsArray[3] + vect(0, 0.2, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
        eventPlayer.TPEntranceText[1] = getLastCreatedText()


rule "Finished Building - TP Exit":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.TPExitCompletion == 100
    
    destroyInWorldText(eventPlayer.TPExitText[1])
    if eventPlayer.BuildingLevelArray[3] != 3:
        createInWorldText(getPlayersInRadius(eventPlayer.BuildingLocationsArray[3], 6, eventPlayer.getTeam(), LosCheck.OFF), "Upgrade: {0} / 200".format(eventPlayer.UpgradeProgressArray[3]), eventPlayer.BuildingLocationsArray[4] + vect(0, 0.2, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
        eventPlayer.TPExitText[1] = getLastCreatedText()


rule "Teleporter - Both buildings finished building / TP upgrade complete":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.TPEntranceCompletion == 100
    @Condition eventPlayer.TPExitCompletion == 100
    
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_LOGO_SOUND, Color.WHITE, eventPlayer.BuildingLocationsArray[3], 100)
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_LOGO_SOUND, Color.WHITE, eventPlayer.BuildingLocationsArray[4], 100)
    #Start charging teleporter
    chase(eventPlayer.TeleporterCharge, 100, rate=33.333 if eventPlayer.BuildingLevelArray[3] == 3 else eventPlayer.BuildingLevelArray[3] * 10, ChaseReeval.DESTINATION_AND_RATE)
    #Teleport immediately available when built
    eventPlayer.TeleporterCharge = 100
    #Set ring color to green
    eventPlayer.TPColor = Color.GREEN
    createInWorldText(getPlayersInRadius(eventPlayer.BuildingLocationsArray[3], 6, eventPlayer.getTeam(), LosCheck.OFF), "Charge: {0}%".format(floor(eventPlayer.TeleporterCharge)), eventPlayer.BuildingLocationsArray[3] + vect(0, 0.1, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.TPEntranceText[2] = getLastCreatedText()
    createInWorldText(getPlayersInRadius(eventPlayer.BuildingLocationsArray[4], 6, eventPlayer.getTeam(), LosCheck.OFF), "Charge: {0}%".format(floor(eventPlayer.TeleporterCharge)), eventPlayer.BuildingLocationsArray[4] + vect(0, 0.1, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.TPExitText[2] = getLastCreatedText()


rule "Looking at sticky destroys it":
    @Event eachPlayer
    @Hero junkrat
    @Condition any([getPlayersInSlot(0, getOppositeTeam(eventPlayer.getTeam())).isInViewAngle(player, 2) for player in eventPlayer.StuckBombLocationsArray]) == true
    @Condition any([getPlayersInSlot(1, getOppositeTeam(eventPlayer.getTeam())).isInViewAngle(player, 2) for player in eventPlayer.StuckBombLocationsArray]) == true
    @Condition any([getPlayersInSlot(2, getOppositeTeam(eventPlayer.getTeam())).isInViewAngle(player, 2) for player in eventPlayer.StuckBombLocationsArray]) == true
    @Condition any([getPlayersInSlot(3, getOppositeTeam(eventPlayer.getTeam())).isInViewAngle(player, 2) for player in eventPlayer.StuckBombLocationsArray]) == true
    @Condition any([getPlayersInSlot(4, getOppositeTeam(eventPlayer.getTeam())).isInViewAngle(player, 2) for player in eventPlayer.StuckBombLocationsArray]) == true
    
    for eventPlayer.Index in range(len(getPlayers(getOppositeTeam(eventPlayer.getTeam())))):
        if any([getPlayersInSlot(eventPlayer.Index, getOppositeTeam(eventPlayer.getTeam())).isInViewAngle(player, 2) for player in eventPlayer.StuckBombLocationsArray]):
            eventPlayer.PlayerLookingAtSticky = getPlayersInSlot(eventPlayer.Index, getOppositeTeam(eventPlayer.getTeam()))
            break
    eventPlayer.StickyBeingLookedAt = sorted(eventPlayer.StuckBombLocationsArray, lambda player: angleBetweenVectors(eventPlayer.PlayerLookingAtSticky.getFacingDirection(), directionTowards(eventPlayer.PlayerLookingAtSticky.getEyePosition(), player)))[0]
    createBeam(getAllPlayers(), Beam.BAD, eventPlayer.PlayerLookingAtSticky.getEyePosition(), eventPlayer.StickyBeingLookedAt, Color.RED, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.AttackStickyBeam = getLastCreatedEntity()
    wait(0.5, Wait.ABORT_WHEN_FALSE)


rule "Initialize Level 3 Sentry (Soldier 76)":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.BuildingLevelArray[1] == 3
    
    createDummy(Hero.SOLDIER, eventPlayer.getTeam(), -1, eventPlayer.Bot1, eventPlayer.Bot1.getFacingDirection())
    eventPlayer.Bot2 = getLastCreatedEntity()
    eventPlayer.Bot2.startForcingName("{0}'s Sentry Rockets".format(eventPlayer))
    eventPlayer.Bot2.Bot1 = eventPlayer.Bot1
    eventPlayer.Bot2.BotOwner = eventPlayer
    eventPlayer.Bot1.Bot2 = getLastCreatedEntity()
    eventPlayer.Bot2.setStatusEffect(null, Status.INVINCIBLE, 9999)
    eventPlayer.Bot2.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.Bot2.setInvisibility(Invis.ALL)
    eventPlayer.Bot2.disablePlayerCollision()
    eventPlayer.Bot2.teleport(eventPlayer.Bot1)
    #Why not just use "facing direciton of" instead of ray cast?
    #eventPlayer.Bot2.startFacing(directionTowards(eventPlayer.Bot2.getEyePosition(), raycast(eventPlayer.Bot1.getEyePosition(), eventPlayer.Bot1.getEyePosition() + eventPlayer.Bot1.getFacingDirection() * 100, getAllPlayers(), getPlayers(eventPlayer.getTeam()), false).getHitPosition()), 50000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    eventPlayer.Bot1.SentryRocketCooldown = 0
    eventPlayer.Bot2.setDamageDealt(99)


rule "Dispenser Link logic / Heal AOE - clear burn after 1s":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() != Hero.SOLDIER
    @Condition eventPlayer.getCurrentHero() != Hero.BASTION
    @Condition distance(eventPlayer, getPlayersOnHero(Hero.TORBJORN, eventPlayer.getTeam()).BuildingLocationsArray[2]) <= 5
    @Condition getPlayersOnHero(Hero.TORBJORN, eventPlayer.getTeam()).DispenserCompletion == 100
    
    createBeam(getAllPlayers(), Beam.GOOD, getPlayersOnHero(Hero.TORBJORN, eventPlayer.getTeam()).BuildingLocationsArray[2], eventPlayer, eventPlayer.getTeam(), EffectReeval.NONE)
    eventPlayer.DispenserBeamEffect = getLastCreatedEntity()
    eventPlayer.startHoT(getPlayersOnHero(Hero.TORBJORN, eventPlayer.getTeam()), 9999, 5 + 5 * eventPlayer.BuildingLevelArray[2])
    eventPlayer.DispenserHealOverTime = getLastHoT()
    #After 1 second of healing, clear any pyro burn
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.clearStatusEffect(Status.BURNING)


rule "Dispenser Unlink logic / Stop Heal AOE":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() != Hero.SOLDIER
    @Condition eventPlayer.getCurrentHero() != Hero.BASTION
    #@Condition distance(eventPlayer, getPlayersOnHero(Hero.TORBJORN, eventPlayer.getTeam()).BuildingLocationsArray[2]) > 5
    #@Condition getPlayersOnHero(Hero.TORBJORN, eventPlayer.getTeam()).DispenserCompletion == 100
    @Condition (distance(eventPlayer, getPlayersOnHero(Hero.TORBJORN, eventPlayer.getTeam()).BuildingLocationsArray[2]) > 5 or getPlayersOnHero(Hero.TORBJORN, eventPlayer.getTeam()).BuildingLocationsArray[2] == null) == true
    
    stopHoT(eventPlayer.DispenserHealOverTime)
    destroyEffect(eventPlayer.DispenserBeamEffect)
    eventPlayer.DispenserBeamEffect = null
    eventPlayer.DispenserHealOverTime = null


/*
rule "Map Metal Spawns":
    @Condition isGameInProgress() == true
    
    if getCurrentMap() == Map.HANAMURA or getCurrentMap() == Map.HANAMURA_WINTER:
        AmmoSpawnLocations[0] = vect(-0.002, 0, -96.469) + vect(0, -0.75, 0)
        AmmoBoxColor[0] = Color.BLUE
        createEffect(getAllPlayers(), Effect.ORB, AmmoBoxColor[0], AmmoSpawnLocations[0], 0.5, EffectReeval.NONE)
        AmmoSpawnEffects[0] = getLastCreatedEntity()
        AmmoSpawnLocations[0] = vect(-14.341, 2, -62.659) + vect(0, -0.75, 0)
        AmmoBoxColor[0] = Color.GREEN
        createEffect(getAllPlayers(), Effect.ORB, AmmoBoxColor[0], AmmoSpawnLocations[0], 0.5, EffectReeval.NONE)
        AmmoSpawnEffects[0] = getLastCreatedEntity()
        AmmoSpawnLocations[0] = vect(0.753, -4.1, -75.328) + vect(0, -0.75, 0)
        AmmoBoxColor[0] = Color.GRAY
        createEffect(getAllPlayers(), Effect.ORB, AmmoBoxColor[0], AmmoSpawnLocations[0], 0.5, EffectReeval.NONE)
        AmmoSpawnEffects[0] = getLastCreatedEntity()
    else:
*/

/*
rule "Pick up map metal when close":
    @Event eachPlayer
    @Hero torbjorn
    @Condition any([distance(eventPlayer, player) <= 1 for player in AmmoSpawnLocations]) == true
    @Condition eventPlayer.EngineerMetal < 200
    
    CurrentIndex = AmmoSpawnLocations.index([player for player in AmmoSpawnLocations if distance(eventPlayer, player) <= 1])
    #If ammo is still respawning
    if AmmoSpawnEffects[CurrentIndex] == null:
        #Wait until it spawns
        waitUntil(AmmoSpawnEffects[CurrentIndex] != null, 100)
        #Then make sure player is still standing on ammo spawn
        if not RULE_CONDITION:
            return
    destroyEffect(AmmoSpawnEffects[CurrentIndex])
    AmmoSpawnEffects[CurrentIndex] = null
    if eventPlayer.EngineerMetal >= 100:
        eventPlayer.EngineerMetal = 200
    else:
        eventPlayer.EngineerMetal += 100
    playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR_SOUND, Color.WHITE, eventPlayer, 100)
    wait(10)
    createEffect(getAllPlayers(), Effect.ORB, Color.GRAY, AmmoSpawnLocations[0], 1, EffectReeval.NONE)
    AmmoSpawnEffects[0] = getLastCreatedEntity()
*/

rule "Clear burn if healing off payload for 1s":
    @Event eachPlayer
    #If gamemode is escort or hybrid (game modes with payload)
    @Condition (getCurrentGamemode() == Gamemode.ESCORT or getCurrentGamemode() == Gamemode.HYBRID) == true
    @Condition eventPlayer.isOnObjective() == true
    @Condition getPayloadProgressPercentage() != 0
    
    wait(1)
    eventPlayer.clearStatusEffect(Status.BURNING)


rule "Double capture speed (spawn dummy bot on objective while capturing)":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isOnObjective() == true
    
    #If escort, dummy on payload
    if getCurrentGamemode() == Gamemode.ESCORT:
        createDummy(Hero.ANA, eventPlayer.getTeam(), -1, getPayloadPosition(), vect(0, 0, 0))
        #If hybrid, dummy on payload if payload progress > 0%
    elif getCurrentGamemode() == Gamemode.HYBRID:
        if getPayloadProgressPercentage() > 0:
            createDummy(Hero.ANA, eventPlayer.getTeam(), -1, getPayloadPosition(), vect(0, 0, 0))
        else:
            createDummy(Hero.ANA, eventPlayer.getTeam(), -1, getObjectivePosition(getCurrentObjective()), vect(0, 0, 0))
        #Any other game mode, dummy on point
    else:
        createDummy(Hero.ANA, eventPlayer.getTeam(), -1, getObjectivePosition(getCurrentObjective()), vect(0, 0, 0))
    eventPlayer.Bot1 = getLastCreatedEntity()
    eventPlayer.Bot1.setInvisibility(Invis.ALL)
    eventPlayer.Bot1.disablePlayerCollision()
    waitUntil(not eventPlayer.isOnObjective(), 99999)
    destroyDummy(eventPlayer.getTeam(), eventPlayer.Bot1.getSlot())


rule "F to toggle third person while cloaked/disguised":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition (eventPlayer.Invisible != 0 or eventPlayer.Disguised) == true
    
    if eventPlayer.ThirdPersonEnabled:
        eventPlayer.stopCamera()
        eventPlayer.ThirdPersonEnabled = false
        if eventPlayer.Invisible == 0:
            eventPlayer.Bot1.setInvisibility(Invis.ENEMIES)
    else:
        eventPlayer.startCamera(eventPlayer.getEyePosition() + worldVector(vect(1, 0, -1.5), eventPlayer, Transform.ROTATION), raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 1000, getAllPlayers(), eventPlayer, true).getHitPosition(), 22)
        eventPlayer.ThirdPersonEnabled = true
        if eventPlayer.Invisible == 0:
            eventPlayer.Bot1.setInvisibility(Invis.NONE)


