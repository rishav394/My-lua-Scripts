-- AutoBroodmother by unknown
-- 

local AutoBroodmother = {}

AutoBroodmother.AutoDefensiveItems = Menu.AddOption({"Hero Specific", "Broodmother"}, "Auto Use Defensive Items", "")
AutoBroodmother.AutoOffensiveItems = Menu.AddOption({"Hero Specific", "Broodmother"}, "Auto Use Offensive Items", "")
AutoBroodmother.FarmKey = Menu.AddKeyOption({"Hero Specific", "Broodmother"}, "Farm Key", Enum.ButtonCode.KEY_F)
AutoBroodmother.ComboKey = Menu.AddKeyOption({"Hero Specific", "Broodmother"}, "Combo Key", Enum.ButtonCode.KEY_SPACE)
AutoBroodmother.UseBlink = Menu.AddOption({"Hero Specific", "Broodmother"}, "Use Blink Dagger", "")
AutoBroodmother.AutoSpellKill = Menu.AddOption({"Hero Specific", "Broodmother"}, "Auto Kill Using Spell", "")
AutoBroodmother.Font = Renderer.LoadFont("Tahoma", 24, Enum.FontWeight.EXTRABOLD)

AutoBroodmother.ProjectileTime = 0
AutoBroodmother.ItemUseTime = 0
AutoBroodmother.HeroAbilityUseTime = 0
AutoBroodmother.UnitAbilityUseTime = 0
AutoBroodmother.Delay = .05
AutoBroodmother.StunTime = 0
AutoBroodmother.StunDuration = 0
AutoBroodmother.AttackOrderTime = 0
AutoBroodmother.MoveOrderTime = 0
AutoBroodmother.FarmManaThreshold = 0.35
AutoBroodmother.CircleDrawTime = 0
AutoBroodmother.OrbWalkTime = 0
AutoBroodmother.CheckDeadTime = 0 
AutoBroodmother.MoveNPCOrderTime = 0
AutoBroodmother.AttackNPCOrderTime = 0
AutoBroodmother.ReadyToInvisTime = nil
AutoBroodmother.NeutralToBuffWithOgre = nil
AutoBroodmother.HeroToBuffWithPriest = nil
AutoBroodmother.HeroToBuffWithOgre = nil
AutoBroodmother.HeroToBuffWithLizard = nil

function AutoBroodmother.OnGameStart()
  AutoBroodmother.ProjectileTime = 0
  AutoBroodmother.ItemUseTime = 0
  AutoBroodmother.HeroAbilityUseTime = 0
  AutoBroodmother.UnitAbilityUseTime = 0
  AutoBroodmother.StunTime = 0
  AutoBroodmother.StunDuration = 0
  AutoBroodmother.AttackOrderTime = 0
  AutoBroodmother.MoveOrderTime = 0
  AutoBroodmother.FarmManaThreshold = 0.35
  AutoBroodmother.CircleDrawTime = 0
  AutoBroodmother.OrbWalkTime = 0
  AutoBroodmother.CheckDeadTime = 0 
  AutoBroodmother.MoveNPCOrderTime = 0
  AutoBroodmother.AttackNPCOrderTime = 0
  AutoBroodmother.ReadyToInvisTime = nil
  AutoBroodmother.NeutralToBuffWithOgre = nil
  AutoBroodmother.HeroToBuffWithPriest = nil
  AutoBroodmother.HeroToBuffWithOgre = nil
  AutoBroodmother.HeroToBuffWithLizard = nil
end

function AutoBroodmother.OnUpdate()
  if not GameRules.GetGameState() == 5 then return end
  if not Heroes.GetLocal() or NPC.GetUnitName(Heroes.GetLocal()) ~= "npc_dota_hero_broodmother" then return end

  local myHero = Heroes.GetLocal()
  local myMana = NPC.GetMana(myHero)
  local myStr = Hero.GetStrengthTotal(myHero)
  local myAgi = Hero.GetAgilityTotal(myHero)
  local myInt = Hero.GetIntellectTotal(myHero)
  local spawn_spiderlings = NPC.GetAbility(myHero, "broodmother_spawn_spiderlings")
  local spin_web = NPC.GetAbility(myHero, "broodmother_spin_web")
  local incapacitating_bite = NPC.GetAbility(myHero, "broodmother_incapacitating_bite")
  local insatiable_hunger = NPC.GetAbility(myHero, "broodmother_insatiable_hunger")
  local spiderling_dmg_plus_60 = NPC.GetAbility(myHero, "special_bonus_unique_broodmother_3")
  local cooldown_reduction_20_percent = NPC.GetAbility(myHero, "special_bonus_cooldown_reduction_20")
  local bonus_hp_250 = NPC.GetAbility(myHero, "special_bonus_hp_250")
  local spider_attack_dmg_plus_12 = NPC.GetAbility(myHero, "special_bonus_unique_broodmother_4")
  local special_bonus_attack_speed_70 = NPC.GetAbility(myHero, "special_bonus_attack_speed_70")
  local plus_8_max_webs = NPC.GetAbility(myHero, "special_bonus_unique_broodmother_1")
  local plus_225_spiders_health = NPC.GetAbility(myHero, "special_bonus_unique_broodmother_2")
  local spawn_spiderlings_cast_range = 700
  local spawn_spiderlings_dmg = nil
  local spin_web_cast_range = 1000
  local item_aether_lens = NPC.GetItem(myHero, "item_aether_lens", true)
  local item_blink = NPC.GetItem(myHero, "item_blink", true)
  local enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
  if enemy then
  local enemyPos = Entity.GetAbsOrigin(enemy)
  end
  local mousePos = Input.GetWorldCursorPos()
  local attackPoint = 0.4
  local mySpellAmp = 1 + (myInt * 0.07142857142) / 100

  if item_aether_lens then
    spawn_spiderlings_cast_range = spawn_spiderlings_cast_range + 220
    spin_web_cast_range = spin_web_cast_range + 220
  end

  if Ability.GetLevel(spawn_spiderlings) > 0 then
    spawn_spiderlings_dmg = Ability.GetLevel(spawn_spiderlings) * 70
    if Ability.GetLevel(spiderling_dmg_plus_60) > 0 then
      spawn_spiderlings_dmg = spawn_spiderlings_dmg + 60
    end
    if mySpellAmp then
      spawn_spiderlings_dmg = spawn_spiderlings_dmg * mySpellAmp
    end
  end

  if Menu.IsEnabled(AutoBroodmother.AutoSpellKill) then
    AutoBroodmother.AutoKill(myHero, myMana, spawn_spiderlings, spawn_spiderlings_dmg, spawn_spiderlings_cast_range)
  end

  AutoBroodmother.AutoUseItems(myHero, myMana)

  if Menu.IsKeyDown(AutoBroodmother.FarmKey) then
    AutoBroodmother.Farm(myHero, myMana, spawn_spiderlings, spawn_spiderlings_dmg, spawn_spiderlings_cast_range)
  end

  if Menu.IsKeyDown(AutoBroodmother.ComboKey) then
    AutoBroodmother.UseItems(myHero, enemy, myMana)
    AutoBroodmother.Combo(myHero, myMana, enemy, enemyPos, mousePos, spawn_spiderlings, insatiable_hunger, item_blink)
  end

end

function AutoBroodmother.AutoKill(myHero, myMana, spawn_spiderlings, spawn_spiderlings_dmg, spawn_spiderlings_cast_range)
  if spawn_spiderlings and spawn_spiderlings_dmg then
    for _, npc in pairs(NPC.GetHeroesInRadius(myHero, spawn_spiderlings_cast_range, Enum.TeamType.TEAM_ENEMY)) do
      if Entity.IsHero(npc) and not NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
        spawn_spiderlings_dmg = NPC.GetMagicalArmorDamageMultiplier(npc) * spawn_spiderlings_dmg
        if Entity.GetHealth(npc) <= spawn_spiderlings_dmg and Ability.IsCastable(spawn_spiderlings, myMana) and Ability.IsReady(spawn_spiderlings) then
          Ability.CastTarget(spawn_spiderlings, npc)
          return 
        end
      end
    end
  end
end

function AutoBroodmother.Farm(myHero, myMana, spawn_spiderlings, spawn_spiderlings_dmg, spawn_spiderlings_cast_range)
  if spawn_spiderlings and spawn_spiderlings_dmg then
    for _, npc in pairs(NPC.GetUnitsInRadius(myHero, spawn_spiderlings_cast_range, Enum.TeamType.TEAM_ENEMY)) do
      if (Entity.GetHealth(npc) < spawn_spiderlings_dmg) and not NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
        if Ability.IsCastable(spawn_spiderlings, myMana) and Ability.IsReady(spawn_spiderlings) then 
          Ability.CastTarget(spawn_spiderlings, npc) 
          return
        end
      end
    end
  end
end

function AutoBroodmother.Combo(myHero, myMana, enemy, enemyPos, mousePos, spawn_spiderlings, insatiable_hunger, item_blink)
  if not AutoBroodmother.IsDisabled(myHero) then
    if not enemy or not Entity.IsAlive(enemy) or Entity.IsDormant(enemy) or Entity.GetHealth(enemy) <= 0 or not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), 500, 0) or NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_ATTACK_IMMUNE) then
      Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, Input.GetWorldCursorPos(), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_SELECTED_UNITS, nil, false, false)
      return 
    end

    if AutoBroodmother.IsSuitableToCastSpell(myHero) then 

      if Menu.IsEnabled(AutoBroodmother.UseBlink) then
        if item_blink and Ability.IsReady(item_blink) and NPC.IsPositionInRange(myHero, NPC.GetAbsOrigin(enemy), 1200 + NPC.GetCastRangeBonus(myHero) + 300, 0) and not NPC.IsPositionInRange(myHero, NPC.GetAbsOrigin(enemy), 300, 0) then 
          Ability.CastPosition(item_blink, enemyPos)
        end
      end

      if spawn_spiderlings and AutoBroodmother.CanCastSpellOn(enemy) and Ability.IsCastable(spawn_spiderlings, myMana) and Ability.IsReady(spawn_spiderlings) and not Ability.IsInAbilityPhase(spawn_spiderlings) and NPC.IsEntityInRange(myHero, enemy, Ability.GetCastRange(spawn_spiderlings)) then 
        Ability.CastTarget(spawn_spiderlings, enemy) 
      end

      if insatiable_hunger and Ability.IsCastable(insatiable_hunger, myMana) and Ability.IsReady(insatiable_hunger) and not Ability.IsInAbilityPhase(insatiable_hunger) and NPC.IsEntityInRange(myHero, enemy, 500) then 
        Ability.CastNoTarget(insatiable_hunger) 
      end
    end

    Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_TARGET, enemy, Vector(0, 0, 0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_SELECTED_UNITS, nil, false, true)

  end
end

function AutoBroodmother.UseItems(myHero, enemy, myMana)
return end

function AutoBroodmother.AutoUseItems(myHero, myMana)
return end

function AutoBroodmother.round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

AutoBroodmother.AncientCreepNameList = {
  "npc_dota_neutral_black_drake",
  "npc_dota_neutral_black_dragon",
  "npc_dota_neutral_blue_dragonspawn_sorcerer",
  "npc_dota_neutral_blue_dragonspawn_overseer",
  "npc_dota_neutral_granite_golem",
  "npc_dota_neutral_elder_jungle_stalker",
  "npc_dota_neutral_prowler_acolyte",
  "npc_dota_neutral_prowler_shaman",
  "npc_dota_neutral_rock_golem",
  "npc_dota_neutral_small_thunder_lizard",
  "npc_dota_neutral_jungle_stalker",
  "npc_dota_neutral_big_thunder_lizard",
  "npc_dota_roshan"
}

-- return best position to cast certain spells
-- eg. axe's call, void's chrono, enigma's black hole
-- input  : unitsAround, radius
-- return : positon (a vector)
function AutoBroodmother.BestPosition(unitsAround, radius)
  if not unitsAround or #unitsAround <= 0 then return nil end
  local enemyNum = #unitsAround

  if enemyNum == 1 then return Entity.GetAbsOrigin(unitsAround[1]) end

  -- find all mid points of every two enemy heroes,
  -- then find out the best position among these.
  -- O(n^3) complexity
  local maxNum = 1
  local bestPos = Entity.GetAbsOrigin(unitsAround[1])
  for i = 1, enemyNum-1 do
    for j = i+1, enemyNum do
      if unitsAround[i] and unitsAround[j] then
        local pos1 = Entity.GetAbsOrigin(unitsAround[i])
        local pos2 = Entity.GetAbsOrigin(unitsAround[j])
        local mid = pos1:__add(pos2):Scaled(0.5)
        local heroesNum = 0
        for k = 1, enemyNum do
          if NPC.IsPositionInRange(unitsAround[k], mid, radius, 0) then
            heroesNum = heroesNum + 1
          end
        end
        if heroesNum > maxNum then
          maxNum = heroesNum
          bestPos = mid
        end
      end
    end
  end
  return bestPos
end

-- return predicted position
function AutoBroodmother.GetPredictedPosition(npc, delay)
  local pos = Entity.GetAbsOrigin(npc)
  if AutoBroodmother.CantMove(npc) then return pos end
  if not NPC.IsRunning(npc) or not delay then return pos end
  local dir = Entity.GetRotation(npc):GetForward():Normalized()
  local speed = AutoBroodmother.GetMoveSpeed(npc)
  return pos + dir:Scaled(speed * delay)
end

function AutoBroodmother.GetMoveSpeed(npc)
  local base_speed = NPC.GetBaseSpeed(npc)
  local bonus_speed = NPC.GetMoveSpeed(npc) - NPC.GetBaseSpeed(npc)
  -- when affected by ice wall, assume move speed as 100 for convenience
  if NPC.HasModifier(npc, "modifier_invoker_ice_wall_slow_debuff") then return 100 end
  -- when get hexed,  move speed = 140/100 + bonus_speed
  if AutoBroodmother.GetHexTimeLeft(npc) > 0 then return 140 + bonus_speed end
  return base_speed + bonus_speed
end

-- return true if is protected by lotus orb or AM's aghs
function AutoBroodmother.IsLotusProtected(npc)
  if NPC.HasModifier(npc, "modifier_item_lotus_orb_active") then return true end
  local shield = NPC.GetAbility(npc, "antimage_spell_shield")
  if shield and Ability.IsReady(shield) and NPC.HasItem(npc, "item_ultimate_scepter", true) then
    return true
  end
  return false
end

-- return true if this npc is disabled, return false otherwise
function AutoBroodmother.IsDisabled(npc)
  if not Entity.IsAlive(npc) then return true end
  if NPC.IsStunned(npc) then return true end
  if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_HEXED) then return true end
  return false
end

-- return true if can cast spell on this npc, return false otherwise
function AutoBroodmother.CanCastSpellOn(npc)
  if Entity.IsDormant(npc) or not Entity.IsAlive(npc) then return false end
  if NPC.IsStructure(npc) then return false end --or not NPC.IsKillable(npc)
  if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then return false end
  if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then return false end
  if NPC.HasModifier(npc, "modifier_abaddon_borrowed_time") then return false end
  return true
end

-- check if it is safe to cast spell or item on enemy
-- in case enemy has blademail or lotus.
-- Caster will take double damage if target has both lotus and blademail
function AutoBroodmother.IsSafeToCast(myHero, enemy, magic_damage)
  if not myHero or not enemy or not magic_damage then return true end
  if magic_damage <= 0 then return true end
  local counter = 0
  if NPC.HasModifier(enemy, "modifier_item_lotus_orb_active") then counter = counter + 1 end
  if NPC.HasModifier(enemy, "modifier_item_blade_mail_reflect") then counter = counter + 1 end
  local reflect_damage = counter * magic_damage * NPC.GetMagicalArmorDamageMultiplier(myHero)
  return Entity.GetHealth(myHero) > reflect_damage
end

-- situations that ally need to be saved
function AutoBroodmother.NeedToBeSaved(npc)
  if not npc or NPC.IsIllusion(npc) or not Entity.IsAlive(npc) then return false end
  if NPC.IsStunned(npc) or NPC.IsSilenced(npc) then return true end
  if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_ROOTED) then return true end
  --if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_DISARMED) then return true end
  if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_HEXED) then return true end
  --if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_PASSIVES_DISABLED) then return true end
  --if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_BLIND) then return true end
  if Entity.GetHealth(npc) <= 0.2 * Entity.GetMaxHealth(npc) then return true end
  return false
end

-- pop all defensive items
function AutoBroodmother.PopDefensiveItems(myHero)
  if not myHero then return end

  -- blade mail
  if NPC.HasItem(myHero, "item_blade_mail", true) then
    local item = NPC.GetItem(myHero, "item_blade_mail", true)
    if Ability.IsCastable(item, NPC.GetMana(myHero)) then
      Ability.CastNoTarget(item)
    end
  end

  -- buckler
  if NPC.HasItem(myHero, "item_buckler", true) then
    local item = NPC.GetItem(myHero, "item_buckler", true)
    if Ability.IsCastable(item, NPC.GetMana(myHero)) then
      Ability.CastNoTarget(item)
    end
  end

  -- hood of defiance
  if NPC.HasItem(myHero, "item_hood_of_defiance", true) then
    local item = NPC.GetItem(myHero, "item_hood_of_defiance", true)
    if Ability.IsCastable(item, NPC.GetMana(myHero)) then
      Ability.CastNoTarget(item)
    end
  end

  -- pipe of insight
  if NPC.HasItem(myHero, "item_pipe", true) then
    local item = NPC.GetItem(myHero, "item_pipe", true)
    if Ability.IsCastable(item, NPC.GetMana(myHero)) then
      Ability.CastNoTarget(item)
    end
  end

  -- crimson guard
  if NPC.HasItem(myHero, "item_crimson_guard", true) then
    local item = NPC.GetItem(myHero, "item_crimson_guard", true)
    if Ability.IsCastable(item, NPC.GetMana(myHero)) then
      Ability.CastNoTarget(item)
    end
  end

  -- shiva's guard
  if NPC.HasItem(myHero, "item_shivas_guard", true) then
    local item = NPC.GetItem(myHero, "item_shivas_guard", true)
    if Ability.IsCastable(item, NPC.GetMana(myHero)) then
      Ability.CastNoTarget(item)
    end
  end

  -- lotus orb
  if NPC.HasItem(myHero, "item_lotus_orb", true) then
    local item = NPC.GetItem(myHero, "item_lotus_orb", true)
    if Ability.IsCastable(item, NPC.GetMana(myHero)) then
      Ability.CastTarget(item, myHero)
    end
  end

  -- mjollnir
  if NPC.HasItem(myHero, "item_mjollnir", true) then
    local item = NPC.GetItem(myHero, "item_mjollnir", true)
    if Ability.IsCastable(item, NPC.GetMana(myHero)) then
      Ability.CastTarget(item, myHero)
    end
  end
end

function AutoBroodmother.IsAncientCreep(npc)
  if not npc then return false end

  for i, name in ipairs(AutoBroodmother.AncientCreepNameList) do
    if name and NPC.GetUnitName(npc) == name then return true end
  end

  return false
end

function AutoBroodmother.CantMove(npc)
  if not npc then return false end

  if NPC.IsRooted(npc) or AutoBroodmother.GetStunTimeLeft(npc) >= 1 then return true end
  if NPC.HasModifier(npc, "modifier_axe_berserkers_call") then return true end
  if NPC.HasModifier(npc, "modifier_legion_commander_duel") then return true end

  return false
end

-- only able to get stun modifier. no specific modifier for root or hex.
function AutoBroodmother.GetStunTimeLeft(npc)
  local mod = NPC.GetModifier(npc, "modifier_stunned")
  if not mod then return 0 end
  return math.max(Modifier.GetDieTime(mod) - GameRules.GetGameTime(), 0)
end

-- hex only has three types: sheepstick, lion's hex, shadow shaman's hex
function AutoBroodmother.GetHexTimeLeft(npc)
  local mod
  local mod1 = NPC.GetModifier(npc, "modifier_sheepstick_debuff")
  local mod2 = NPC.GetModifier(npc, "modifier_lion_voodoo")
  local mod3 = NPC.GetModifier(npc, "modifier_shadow_shaman_voodoo")

  if mod1 then mod = mod1 end
  if mod2 then mod = mod2 end
  if mod3 then mod = mod3 end

  if not mod then return 0 end
  return math.max(Modifier.GetDieTime(mod) - GameRules.GetGameTime(), 0)
end

-- return false for conditions that are not suitable to cast spell (like TPing, being invisible)
-- return true otherwise
function AutoBroodmother.IsSuitableToCastSpell(myHero)
  if NPC.IsSilenced(myHero) or NPC.IsStunned(myHero) or not Entity.IsAlive(myHero) then return false end
  --if NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then return false end
  if NPC.HasModifier(myHero, "modifier_teleporting") then return false end
  if NPC.IsChannellingAbility(myHero) then return false end
  return true
end

function AutoBroodmother.IsSuitableToUseItem(myHero)
  if NPC.IsStunned(myHero) or not Entity.IsAlive(myHero) then return false end
  if NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then return false end
  if NPC.HasModifier(myHero, "modifier_teleporting") then return false end
  if NPC.IsChannellingAbility(myHero) then return false end
  return true
end

-- return true if: (1) channeling ability; (2) TPing
function AutoBroodmother.IsChannellingAbility(npc, target)
  if NPC.HasModifier(npc, "modifier_teleporting") then return true end
  if NPC.IsChannellingAbility(npc) then return true end

  return false
end

function AutoBroodmother.IsAffectedByDoT(npc)
  if not npc then return false end

  if NPC.HasModifier(npc, "modifier_item_radiance_debuff") then return true end
  if NPC.HasModifier(npc, "modifier_item_urn_damage") then return true end
  if NPC.HasModifier(npc, "modifier_alchemist_acid_spray") then return true end
  if NPC.HasModifier(npc, "modifier_cold_feet") then return true end
  if NPC.HasModifier(npc, "modifier_ice_blast") then return true end
  if NPC.HasModifier(npc, "modifier_axe_battle_hunger") then return true end
  if NPC.HasModifier(npc, "modifier_bane_fiends_grip") then return true end
  if NPC.HasModifier(npc, "modifier_batrider_firefly") then return true end
  if NPC.HasModifier(npc, "modifier_rattletrap_battery_assault") then return true end
  if NPC.HasModifier(npc, "modifier_crystal_maiden_frostbite") then return true end
  if NPC.HasModifier(npc, "modifier_crystal_maiden_freezing_field") then return true end
  if NPC.HasModifier(npc, "modifier_dazzle_poison_touch") then return true end
  if NPC.HasModifier(npc, "modifier_disruptor_static_storm") then return true end
  if NPC.HasModifier(npc, "modifier_disruptor_thunder_strike") then return true end
  if NPC.HasModifier(npc, "modifier_doom_bringer_doom") then return true end
  if NPC.HasModifier(npc, "modifier_doom_bringer_scorched_earth_effect") then return true end
  if NPC.HasModifier(npc, "modifier_dragon_knight_corrosive_breath_dot") then return true end
  if NPC.HasModifier(npc, "modifier_earth_spirit_magnetize") then return true end
  if NPC.HasModifier(npc, "modifier_ember_spirit_flame_guard") then return true end
  if NPC.HasModifier(npc, "modifier_enigma_malefice") then return true end
  if NPC.HasModifier(npc, "modifier_brewmaster_fire_permanent_immolation") then return true end
  if NPC.HasModifier(npc, "modifier_gyrocopter_rocket_barrage") then return true end
  if NPC.HasModifier(npc, "modifier_huskar_burning_spear_debuff") then return true end
  if NPC.HasModifier(npc, "modifier_invoker_ice_wall_slow_debuff") then return true end
  if NPC.HasModifier(npc, "modifier_invoker_chaos_meteor_burn") then return true end
  if NPC.HasModifier(npc, "modifier_jakiro_dual_breath_burn") then return true end
  if NPC.HasModifier(npc, "modifier_jakiro_macropyre") then return true end
  if NPC.HasModifier(npc, "modifier_juggernaut_blade_fury") then return true end
  if NPC.HasModifier(npc, "modifier_leshrac_diabolic_edict") then return true end
  if NPC.HasModifier(npc, "modifier_leshrac_pulse_nova") then return true end
  if NPC.HasModifier(npc, "modifier_ogre_magi_ignite") then return true end
  if NPC.HasModifier(npc, "modifier_phoenix_fire_spirit_burn") then return true end
  if NPC.HasModifier(npc, "modifier_phoenix_icarus_dive_burn") then return true end
  if NPC.HasModifier(npc, "modifier_phoenix_sun_debuff") then return true end
  if NPC.HasModifier(npc, "modifier_pudge_rot") then return true end
  if NPC.HasModifier(npc, "modifier_pugna_life_drain") then return true end
  if NPC.HasModifier(npc, "modifier_queenofpain_shadow_strike") then return true end
  if NPC.HasModifier(npc, "modifier_razor_eye_of_the_storm") then return true end
  if NPC.HasModifier(npc, "modifier_sandking_sand_storm") then return true end
  if NPC.HasModifier(npc, "modifier_silencer_curse_of_the_silent") then return true end
  if NPC.HasModifier(npc, "modifier_sniper_shrapnel_slow") then return true end
  if NPC.HasModifier(npc, "modifier_shredder_chakram_debuff") then return true end
  if NPC.HasModifier(npc, "modifier_treant_leech_seed") then return true end
  if NPC.HasModifier(npc, "modifier_abyssal_underlord_firestorm_burn") then return true end
  if NPC.HasModifier(npc, "modifier_venomancer_venomous_gale") then return true end
  if NPC.HasModifier(npc, "modifier_venomancer_poison_nova") then return true end
  if NPC.HasModifier(npc, "modifier_viper_viper_strike") then return true end
  if NPC.HasModifier(npc, "modifier_warlock_shadow_word") then return true end
  if NPC.HasModifier(npc, "modifier_warlock_golem_permanent_immolation_debuff") then return true end
  if NPC.HasModifier(npc, "modifier_maledict") then return true end

  return false
end

AutoBroodmother.CreepNameList = {
"npc_dota_neutral_alpha_wolf",
"npc_dota_neutral_big_thunder_lizard",
"npc_dota_neutral_black_dragon",
"npc_dota_neutral_black_drake",
"npc_dota_neutral_blue_dragonspawn_overseer",
"npc_dota_neutral_blue_dragonspawn_sorcerer",
"npc_dota_neutral_centaur_khan",
"npc_dota_neutral_centaur_outrunner",
"npc_dota_neutral_dark_troll",
"npc_dota_neutral_dark_troll_warlord",
"npc_dota_neutral_elder_jungle_stalker",
"npc_dota_neutral_enraged_wildkin",
"npc_dota_neutral_fel_beast",
"npc_dota_neutral_forest_troll_berserker",
"npc_dota_neutral_forest_troll_high_priest",
"npc_dota_neutral_ghost",
"npc_dota_neutral_giant_wolf",
"npc_dota_neutral_gnoll_assassin",
"npc_dota_neutral_granite_golem",
"npc_dota_neutral_harpy_scout",
"npc_dota_neutral_harpy_storm",
"npc_dota_neutral_jungle_stalker",
"npc_dota_neutral_kobold",
"npc_dota_neutral_kobold_taskmaster",
"npc_dota_neutral_kobold_tunneler",
"npc_dota_neutral_mud_golem",
"npc_dota_neutral_ogre_magi",
"npc_dota_neutral_ogre_mauler",
"npc_dota_neutral_polar_furbolg_champion",
"npc_dota_neutral_polar_furbolg_ursa_warrior",
"npc_dota_neutral_rock_golem",
"npc_dota_neutral_satyr_hellcaller",
"npc_dota_neutral_satyr_soulstealer",
"npc_dota_neutral_satyr_trickster",
"npc_dota_neutral_small_thunder_lizard",
"npc_dota_neutral_wildkin",
"npc_dota_neutral_prowler_shaman",
"npc_dota_neutral_prowler_acolyte"
}

AutoBroodmother.UsefulCreepNameList = {
"npc_dota_neutral_granite_golem",
"npc_dota_neutral_black_dragon",
"npc_dota_neutral_big_thunder_lizard",
"npc_dota_neutral_satyr_hellcaller",
"npc_dota_neutral_dark_troll_warlord",
"npc_dota_neutral_centaur_khan",
"npc_dota_neutral_enraged_wildkin",
"npc_dota_neutral_alpha_wolf",
"npc_dota_neutral_ogre_magi",
"npc_dota_neutral_polar_furbolg_ursa_warrior",
"npc_dota_neutral_prowler_acolyte",
"npc_dota_neutral_prowler_shaman",
"npc_dota_neutral_harpy_storm",
"npc_dota_neutral_mud_golem",
"npc_dota_neutral_ghost",
"npc_dota_neutral_forest_troll_high_priest",
"npc_dota_neutral_kobold_taskmaster"
}

AutoBroodmother.InteractiveAbilities = {
"forest_troll_high_priest_heal",
"harpy_storm_chain_lightning",
"centaur_khan_war_stomp",
"satyr_trickster_purge",
"satyr_soulstealer_mana_burn",
"ogre_magi_frost_armor",
"mud_golem_hurl_boulder",
"satyr_hellcaller_shockwave",
"polar_furbolg_ursa_warrior_thunder_clap",
"enraged_wildkin_tornado",
"dark_troll_warlord_ensnare",
"dark_troll_warlord_raise_dead",
"black_dragon_fireball",
"big_thunder_lizard_slam",
"big_thunder_lizard_frenzy",
"spawnlord_master_stomp",
"spawnlord_master_freeze"
}

AutoBroodmother.HeroAbilities = {
"broodmother_spawn_spiderlings",
"broodmother_spin_web",
"broodmother_incapacitating_bite",
"broodmother_insatiable_hunger",
"special_bonus_unique_broodmother_3",
"special_bonus_exp_boost_25",
"special_bonus_cooldown_reduction_20",
"special_bonus_hp_350",
"special_bonus_unique_broodmother_4",
"special_bonus_attack_speed_70",
"special_bonus_unique_broodmother_1",
"special_bonus_unique_broodmother_2"
}

AutoBroodmother.Items = {
"item_abyssal_blade",
"item_aegis",
"item_aether_lens",
"item_ancient_janggo",
"item_arcane_boots",
"item_armlet",
"item_assault",
"item_banana",
"item_basher",
"item_belt_of_strength",
"item_bfury",
"item_black_king_bar",
"item_blade_mail",
"item_blade_of_alacrity",
"item_blades_of_attack",
"item_blight_stone",
"item_bloodstone",
"item_bloodthorn",
"item_boots",
"item_boots_of_elves",
"item_bottle",
"item_bracer",
"item_branches",
"item_broadsword",
"item_buckler",
"item_butterfly",
"item_chainmail",
"item_cheese",
"item_circlet",
"item_clarity",
"item_claymore",
"item_cloak",
"item_courier",
"item_crimson_guard",
"item_cyclone",
"item_dagon",
"item_dagon_2",
"item_dagon_3",
"item_dagon_4",
"item_dagon_5",
"item_demon_edge",
"item_desolator",
"item_diffusal_blade",
"item_diffusal_blade_2",
"item_dragon_lance",
"item_dust",
"item_eagle",
"item_echo_sabre",
"item_enchanted_mango",
"item_energy_booster",
"item_ethereal_blade",
"item_faerie_fire",
"item_flask",
"item_flying_courier",
"item_force_staff",
"item_gauntlets",
"item_gem",
"item_ghost",
"item_glimmer_cape",
"item_gloves",
"item_greater_crit",
"item_greevil_whistle",
"item_greevil_whistle_toggle",
"item_guardian_greaves",
"item_halloween_candy_corn",
"item_halloween_rapier",
"item_hand_of_midas",
"item_headdress",
"item_heart",
"item_heavens_halberd",
"item_helm_of_iron_will",
"item_helm_of_the_dominator",
"item_hood_of_defiance",
"item_hurricane_pike",
"item_hyperstone",
"item_infused_raindrop",
"item_invis_sword",
"item_iron_talon",
"item_javelin",
"item_lesser_crit",
"item_lifesteal",
"item_lotus_orb",
"item_maelstrom",
"item_magic_stick",
"item_magic_wand",
"item_manta",
"item_mantle",
"item_mask_of_madness",
"item_medallion_of_courage",
"item_mekansm",
"item_mithril_hammer",
"item_mjollnir",
"item_monkey_king_bar",
"item_moon_shard",
"item_mystery_arrow",
"item_mystery_hook",
"item_mystery_missile",
"item_mystery_toss",
"item_mystery_vacuum",
"item_mystic_staff",
"item_necronomicon",
"item_necronomicon_2",
"item_necronomicon_3",
"item_null_talisman",
"item_oblivion_staff",
"item_octarine_core",
"item_ogre_axe",
"item_orb_of_venom",
"item_orchid",
"item_pers",
"item_phase_boots",
"item_pipe",
"item_platemail",
"item_point_booster",
"item_poor_mans_shield",
"item_power_treads",
"item_present",
"item_quarterstaff",
"item_quelling_blade",
"item_radiance",
"item_rapier",
"item_reaver",
"item_recipe_abyssal_blade",
"item_recipe_aether_lens",
"item_recipe_ancient_janggo",
"item_recipe_arcane_boots",
"item_recipe_armlet",
"item_recipe_assault",
"item_recipe_basher",
"item_recipe_bfury",
"item_recipe_black_king_bar",
"item_recipe_blade_mail",
"item_recipe_bloodstone",
"item_recipe_bloodthorn",
"item_recipe_bracer",
"item_recipe_buckler",
"item_recipe_butterfly",
"item_recipe_crimson_guard",
"item_recipe_cyclone",
"item_recipe_dagon",
"item_recipe_dagon_2",
"item_recipe_dagon_3",
"item_recipe_dagon_4",
"item_recipe_dagon_5",
"item_recipe_desolator",
"item_recipe_diffusal_blade",
"item_recipe_diffusal_blade_2",
"item_recipe_dragon_lance",
"item_recipe_echo_sabre",
"item_recipe_ethereal_blade",
"item_recipe_force_staff",
"item_recipe_glimmer_cape",
"item_recipe_greater_crit",
"item_recipe_guardian_greaves",
"item_recipe_hand_of_midas",
"item_recipe_headdress",
"item_recipe_heart",
"item_recipe_heavens_halberd",
"item_recipe_helm_of_the_dominator",
"item_recipe_hood_of_defiance",
"item_recipe_hurricane_pike",
"item_recipe_invis_sword",
"item_recipe_iron_talon",
"item_recipe_lesser_crit",
"item_recipe_lotus_orb",
"item_recipe_maelstrom",
"item_recipe_magic_wand",
"item_recipe_manta",
"item_recipe_mask_of_madness",
"item_recipe_medallion_of_courage",
"item_recipe_mekansm",
"item_recipe_mjollnir",
"item_recipe_monkey_king_bar",
"item_recipe_moon_shard",
"item_recipe_necronomicon",
"item_recipe_necronomicon_2",
"item_recipe_necronomicon_3",
"item_recipe_null_talisman",
"item_recipe_oblivion_staff",
"item_recipe_octarine_core",
"item_recipe_orchid",
"item_recipe_pers",
"item_recipe_phase_boots",
"item_recipe_pipe",
"item_recipe_poor_mans_shield",
"item_recipe_power_treads",
"item_recipe_radiance",
"item_recipe_rapier",
"item_recipe_refresher",
"item_recipe_ring_of_aquila",
"item_recipe_ring_of_basilius",
"item_recipe_rod_of_atos",
"item_recipe_sange",
"item_recipe_sange_and_yasha",
"item_recipe_satanic",
"item_recipe_sheepstick",
"item_recipe_shivas_guard",
"item_recipe_silver_edge",
"item_recipe_skadi",
"item_recipe_solar_crest",
"item_recipe_soul_booster",
"item_recipe_soul_ring",
"item_recipe_sphere",
"item_recipe_tranquil_boots",
"item_recipe_travel_boots",
"item_recipe_travel_boots_2",
"item_recipe_ultimate_scepter",
"item_recipe_urn_of_shadows",
"item_recipe_vanguard",
"item_recipe_veil_of_discord",
"item_recipe_vladmir",
"item_recipe_ward_dispenser",
"item_recipe_wraith_band",
"item_recipe_yasha",
"item_refresher",
"item_relic",
"item_ring_of_aquila",
"item_ring_of_basilius",
"item_ring_of_health",
"item_ring_of_protection",
"item_ring_of_regen",
"item_river_painter",
"item_river_painter2",
"item_river_painter3",
"item_river_painter4",
"item_river_painter5",
"item_river_painter6",
"item_river_painter7",
"item_robe",
"item_rod_of_atos",
"item_sange",
"item_sange_and_yasha",
"item_satanic",
"item_shadow_amulet",
"item_sheepstick",
"item_shivas_guard",
"item_silver_edge",
"item_skadi",
"item_slippers",
"item_smoke_of_deceit",
"item_sobi_mask",
"item_solar_crest",
"item_soul_booster",
"item_soul_ring",
"item_sphere",
"item_staff_of_wizardry",
"item_stout_shield",
"item_talisman_of_evasion",
"item_tango",
"item_tango_single",
"item_tome_of_knowledge",
"item_tpscroll",
"item_tranquil_boots",
"item_travel_boots",
"item_travel_boots_2",
"item_ultimate_orb",
"item_ultimate_scepter",
"item_urn_of_shadows",
"item_vanguard",
"item_veil_of_discord",
"item_vitality_booster",
"item_vladmir",
"item_void_stone",
"item_ward_dispenser",
"item_ward_observer",
"item_ward_sentry",
"item_wind_lace",
"item_winter_cake",
"item_winter_coco",
"item_winter_cookie",
"item_winter_greevil_chewy",
"item_winter_greevil_garbage",
"item_winter_greevil_treat",
"item_winter_ham",
"item_winter_kringle",
"item_winter_mushroom",
"item_winter_skates",
"item_winter_stocking",
"item_wraith_band",
"item_yasha"
}

AutoBroodmother.InteractiveItems = {
"item_sheepstick",
"item_orchid",
"item_bloodthorn",
"item_rod_of_atos",
"item_veil_of_discord",
"item_heavens_halberd",
"item_abyssal_blade",
"item_diffusal_blade",
"item_diffusal_blade_2",
"item_ethereal_blade",
"item_medallion_of_courage",
"item_shivas_guard",
"item_solar_crest",
"item_hurricane_pike",
"item_satanic",
"item_ancient_janggo",
"item_dagon",
"item_dagon_2",
"item_dagon_3",
"item_dagon_4",
"item_dagon_5",
"item_black_king_bar",
"item_pipe",
"item_blade_mail",
"item_buckler",
"item_hood_of_defiance",
"item_lotus_orb",
"item_manta",
"item_mask_of_madness",
"item_mjollnir",
"item_necronomicon",
"item_necronomicon_2",
"item_necronomicon_3",
"item_urn_of_shadows",
}

AutoBroodmother.InteractiveAutoItems = {
"item_magic_stick",
"item_magic_wand",
"item_mekansm",
"item_guardian_greaves",
"item_arcane_boots"
}

return AutoBroodmother