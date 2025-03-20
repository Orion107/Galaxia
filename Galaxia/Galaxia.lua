SMODS.Keybind{
    key_pressed = 'f5',
    action = function(self)
        SMODS.restart_game()
    end,
}

SMODS.Atlas{
  -- Key for code to find it with
  key = "Galaxia",
  -- The name of the file, for the code to pull the atlas from
  path = "Galaxia.png",
  -- Width of each sprite in 1x size
  px = 71,
  -- Height of each sprite in 1x size
  py = 95
}
SMODS.Enhancement{
key = 'holy',
  loc_txt = {
    name = 'Holy Card',
    text = {
	"{C:chips}+333{} Chips",
      "{X:mult,C:white}x3.33{} Mult"
    }
  },
  config = {x_mult = 3.33, bonus = 333},
  atlas = 'Galaxia',
  pos = {x = 7, y = 0},
  }
SMODS.Joker{
  key = 'andromeda0',
  loc_txt = {
    name = '???',
    text = {
      "Gains {C:chips}+#2#{} Chips",
      "at the end of the round.",
	  "{C:green} 1 in 4{} chance to run away",
	  "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
	  "{C:inactive} {s:0.75} Who are you...?"
	 
    }
  },
  no_pool_flag = 'andromeda0_run',
  config = {extra = {chips = 0, chip_gain = 100, odds = 4}},
  rarity = 2,
  atlas = 'Galaxia',
  pos = {x = 0, y = 0},
  cost = 10,
    eternal_compat = false,
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.chips, card.ability.extra.chip_gain, card.ability.extra.odds, (G.GAME.probabilities.normal or 1)}}
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        chip_mod = card.ability.extra.chips,
        message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}
      }
    end
    
    -- context.before checks if context.before == true, and context.before is true when it's before the current hand is scored.
    -- context.scoring_name == 'Straight' checks if the current hand is a 'Straight'.
    -- not context.blueprint ensures that Blueprint or Brainstorm don't copy this upgrading part of the joker, but that it'll still copy the added chips.
    if context.end_of_round and context.main_eval and not context.blueprint then
      -- Updated variable is equal to current variable, plus the amount of chips in chip gain.
      -- 15 = 0+15, 30 = 15+15, 75 = 60+15.
      card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
    end
	if context.end_of_round and context.main_eval and not context.repetition and not context.game_over and not context.blueprint then
      -- Another pseudorandom thing, randomly generates a decimal between 0 and 1, so effectively a random percentage.
      if pseudorandom('andromeda0') < G.GAME.probabilities.normal/4 then
        -- This part plays the animation.
        G.E_MANAGER:add_event(Event({
              func = function()
                play_sound('tarot1')
                card.T.r = -0.2
                card:juice_up(0.3, 0.4)
                card.states.drag.is = true
                card.children.center.pinch.x = true
                -- This part destroys the card.
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                      func = function()
                        G.jokers:remove_card(card)
                        card:remove()
                        card = nil
                        return true; end})) 
                  return true
                end
              })) 
          -- Sets the pool flag to true, meaning ??? doesn't spawn, and Andromeda..? does.
          G.GAME.pool_flags.andromeda0_run = true
          return {
            message = 'Ran away!'
          }
        else
          return {
            message = 'Stayed around!',
        colour = G.C.CHIPS,
        -- The return value, "card", is set to the variable "card", which is the joker.
        -- Basically, this tells the return value what it's affecting, which if it's the joker itself, it's usually card.
        -- It can be things like card = context.other_card in some cases, so specifying card (return value) = card (variable from function) is required.
        card = card
          }
        end
      end
  end
}

SMODS.Joker{
  key = 'andromeda1',
  loc_txt = {
    name = 'Unrecognizable',
    text = {
      "Gains {C:mult}+#2#{} Mult",
      "at the end of the round.",
	  "{C:green} 1 in 8{} chance to run away",
	  "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
	  "{C:inactive} {s:0.75} Why do I recognize you??"
	 
    }
  },
  yes_pool_flag = 'andromeda0_run',
  no_pool_flag = 'andromeda1_run',
  config = {extra = {mult = 0, mult_gain = 20, odds = 8}},
  rarity = 3,
  atlas = 'Galaxia',
  pos = {x = 1, y = 0},
  cost = 12,
    eternal_compat = false,
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult, card.ability.extra.mult_gain, card.ability.extra.odds, (G.GAME.probabilities.normal or 1)}}
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult_mod = card.ability.extra.mult,
        message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}
      }
    end
    
    -- context.before checks if context.before == true, and context.before is true when it's before the current hand is scored.
    -- context.scoring_name == 'Straight' checks if the current hand is a 'Straight'.
    -- not context.blueprint ensures that Blueprint or Brainstorm don't copy this upgrading part of the joker, but that it'll still copy the added chips.
    if context.end_of_round and context.main_eval and not context.blueprint then
      -- Updated variable is equal to current variable, plus the amount of chips in chip gain.
      -- 15 = 0+15, 30 = 15+15, 75 = 60+15.
      card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
    end
	if context.end_of_round and context.main_eval and not context.repetition and not context.game_over and not context.blueprint then
      -- Another pseudorandom thing, randomly generates a decimal between 0 and 1, so effectively a random percentage.
      if pseudorandom('andromeda1') < G.GAME.probabilities.normal/8 then
        -- This part plays the animation.
        G.E_MANAGER:add_event(Event({
              func = function()
                play_sound('tarot1')
                card.T.r = -0.2
                card:juice_up(0.3, 0.4)
                card.states.drag.is = true
                card.children.center.pinch.x = true
                -- This part destroys the card.
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                      func = function()
                        G.jokers:remove_card(card)
                        card:remove()
                        card = nil
                        return true; end})) 
                  return true
                end
              })) 
          -- Sets the pool flag to true, meaning Andromeda..? doesn't spawn, and Andromeda does.
          G.GAME.pool_flags.andromeda1_run = true
          return {
            message = 'Ran away!'
          }
        else
          return {
            message = 'Stayed around!',
        colour = G.C.MULT,
        -- The return value, "card", is set to the variable "card", which is the joker.
        -- Basically, this tells the return value what it's affecting, which if it's the joker itself, it's usually card.
        -- It can be things like card = context.other_card in some cases, so specifying card (return value) = card (variable from function) is required.
        card = card
          }
        end
      end
  end
}
SMODS.Joker{
  key = 'andromeda2',
  loc_txt = {
    name = 'Recognizable..?',
    text = {
      "Gains {X:mult,C:white}x#2#{} Mult",
      "at the end of the round.",
	  "{C:green} 1 in 16{} chance to run away",
	  "{C:inactive}(Currently {X:mult,C:white}x#1#{C:inactive} Mult)",
	  "{C:inactive} {s:0.8} Oh, hey Sage! It's me!"
	 
    }
  },
  yes_pool_flag = 'andromeda1_run',
  no_pool_flag = 'andromeda2_run',
  config = {extra = {Xmult = 1, Xmult_gain = 4, odds = 8}},
  rarity = "cry_epic",
  atlas = 'Galaxia',
  pos = {x = 2, y = 0},
  cost = 24,
    eternal_compat = false,
	dependencies = {
		items = {
			"set_cry_epic",
		},
	},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult, card.ability.extra.Xmult_gain, card.ability.extra.odds, (G.GAME.probabilities.normal or 1)}}
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        Xmult_mod = card.ability.extra.Xmult,
        message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}}
      }
    end
    
    -- context.before checks if context.before == true, and context.before is true when it's before the current hand is scored.
    -- context.scoring_name == 'Straight' checks if the current hand is a 'Straight'.
    -- not context.blueprint ensures that Blueprint or Brainstorm don't copy this upgrading part of the joker, but that it'll still copy the added chips.
    if context.end_of_round and context.main_eval and not context.blueprint then
      -- Updated variable is equal to current variable, plus the amount of chips in chip gain.
      -- 15 = 0+15, 30 = 15+15, 75 = 60+15.
      card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
    end
	if context.end_of_round and context.main_eval and not context.repetition and not context.game_over and not context.blueprint then
      -- Another pseudorandom thing, randomly generates a decimal between 0 and 1, so effectively a random percentage.
      if pseudorandom('andromeda2') < G.GAME.probabilities.normal/16 then
        -- This part plays the animation.
        G.E_MANAGER:add_event(Event({
              func = function()
                play_sound('tarot1')
                card.T.r = -0.2
                card:juice_up(0.3, 0.4)
                card.states.drag.is = true
                card.children.center.pinch.x = true
                -- This part destroys the card.
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                      func = function()
                        G.jokers:remove_card(card)
                        card:remove()
                        card = nil
                        return true; end})) 
                  return true
                end
              })) 
          -- Sets the pool flag to true, meaning Andromeda..? doesn't spawn, and Andromeda does.
          G.GAME.pool_flags.andromeda2_run = true
          return {
            message = 'Ran away!'
          }
        else
          return {
            message = 'Stayed around!',
        colour = G.C.MULT,
        -- The return value, "card", is set to the variable "card", which is the joker.
        -- Basically, this tells the return value what it's affecting, which if it's the joker itself, it's usually card.
        -- It can be things like card = context.other_card in some cases, so specifying card (return value) = card (variable from function) is required.
        card = card
          }
        end
      end
  end
}
SMODS.Joker{
  key = 'andromeda3',
  loc_txt = {
    name = 'Andromeda',
    text = {
      "Gains {X:edition,C:black,s:1.25}^#2#{} Mult",
      "at the end of the round.",
	  "{C:green} 1 in 32{} chance to run away",
	  "{C:inactive}(Currently {X:edition,C:black,s:1.05}^#1#{C:inactive} Mult)",
	  "{C:inactive} {s:0.85} Your best friend..."
	 
    }
  },
  yes_pool_flag = 'andromeda2_run',
  no_pool_flag = 'andromeda3_run',
  config = {extra = {emult = 1, emult_gain = 0.8, odds = 8}},
  rarity = 4,
  atlas = 'Galaxia',
  pos = {x = 3, y = 0},
  cost = 270,
    eternal_compat = false,
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.emult, card.ability.extra.emult_gain, card.ability.extra.odds, (G.GAME.probabilities.normal or 1)}}
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        Emult_mod = card.ability.extra.emult,
        message = localize{type = 'variable', key = 'a_emult', vars = {card.ability.extra.emult}}
      }
    end
    
    -- context.before checks if context.before == true, and context.before is true when it's before the current hand is scored.
    -- context.scoring_name == 'Straight' checks if the current hand is a 'Straight'.
    -- not context.blueprint ensures that Blueprint or Brainstorm don't copy this upgrading part of the joker, but that it'll still copy the added chips.
    if context.end_of_round and context.main_eval and not context.blueprint then
      -- Updated variable is equal to current variable, plus the amount of chips in chip gain.
      -- 15 = 0+15, 30 = 15+15, 75 = 60+15.
      card.ability.extra.emult = card.ability.extra.emult + card.ability.extra.emult_gain
    end
	if context.end_of_round and context.main_eval and not context.repetition and not context.game_over and not context.blueprint then
      -- Another pseudorandom thing, randomly generates a decimal between 0 and 1, so effectively a random percentage.
      if pseudorandom('andromeda2') < G.GAME.probabilities.normal/32 then
        -- This part plays the animation.
        G.E_MANAGER:add_event(Event({
              func = function()
                play_sound('tarot1')
                card.T.r = -0.2
                card:juice_up(0.3, 0.4)
                card.states.drag.is = true
                card.children.center.pinch.x = true
                -- This part destroys the card.
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                      func = function()
                        G.jokers:remove_card(card)
                        card:remove()
                        card = nil
                        return true; end})) 
                  return true
                end
              })) 
          -- Sets the pool flag to true, meaning Andromeda doesn't spawn, and GALAXIA does.
          G.GAME.pool_flags.andromeda3_run = true
          return {
            message = 'Ran away!'
          }
        else
          return {
            message = 'Stayed around!',
        colour = G.C.EDITION,
        -- The return value, "card", is set to the variable "card", which is the joker.
        -- Basically, this tells the return value what it's affecting, which if it's the joker itself, it's usually card.
        -- It can be things like card = context.other_card in some cases, so specifying card (return value) = card (variable from function) is required.
        card = card
          }
        end
      end
  end
}
SMODS.Joker{
	dependencies = {
		items = {
			"c_cry_gateway",
			"set_cry_exotic",
		},
	},
  key = 'galaxia',
  loc_txt = {
    name = 'GALAXIA',
    text = {
      "Gains {X:dark_edition,C:white,s:1.75}^^^#2#{} Mult",
      "at the end of the round.",
	  "{C:inactive}(Currently {X:dark_edition,C:white,s:1.15}^^^#1#{C:inactive} Mult)",
	  "{C:inactive}{s:0.7}..."
	 
    }
  },
  yes_pool_flag = 'andromeda3_run',
  config = {extra = {eeemult = 1, eeemult_gain = 0.16, odds = 8}},
  rarity = "cry_exotic",
  atlas = 'Galaxia',
  pos = {x = 4, y = 0},
  cost = 810,
    eternal_compat = false,
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.eeemult, card.ability.extra.eeemult_gain, card.ability.extra.odds, (G.GAME.probabilities.normal or 1)}}
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        EEEmult_mod = card.ability.extra.eeemult,
        message = localize{type = 'variable', key = 'a_eeemult', vars = {card.ability.extra.eeemult}}
      }
    end
    
    -- context.before checks if context.before == true, and context.before is true when it's before the current hand is scored.
    -- context.scoring_name == 'Straight' checks if the current hand is a 'Straight'.
    -- not context.blueprint ensures that Blueprint or Brainstorm don't copy this upgrading part of the joker, but that it'll still copy the added chips.
    if context.end_of_round and context.main_eval and not context.blueprint then
      -- Updated variable is equal to current variable, plus the amount of chips in chip gain.
      -- 15 = 0+15, 30 = 15+15, 75 = 60+15.
      card.ability.extra.eeemult = card.ability.extra.eeemult + card.ability.extra.eeemult_gain
    end
	end
}
SMODS.Joker{
  key = 'Sage',
  loc_txt = {
    name = 'Sage',
    text = {
      "Gives {C:attention}all played cards{}",
      "this Joker's {C:dark_edition}edition{}.",
	  "Joker's {C:dark_edition}edition{} changes",
	  "before hand is played.",
	  "{C:black,s:0.8}Hey, Andra!"
    }
  },
  -- Extra is empty, because it only happens once. If you wanted to copy multiple cards, you'd need to restructure the code and add a for loop or something.
  no_pool_flag = 'Sage_run',
  config = {extra = {}},
  rarity = "cry_epic",
  atlas = 'Galaxia',
  pos = {x = 5, y = 0},
  cost = 25,
  calculate = function(self, card, context)
   if context.before and context.main_eval then
   card:set_edition(poll_edition("Sage", 1, true, true, {{name = 'e_foil', weight = 1,}, {name = 'e_holo', weight = 1,}, {name = 'e_polychrome', weight = 1,}, {name = 'e_cry_mosaic', weight = 1,}, {name = 'e_cry_gold', weight = 1,}, {name = 'e_cry_astral', weight = 1,}, }), true)
	for _, pcard in ipairs(context.full_hand) do

   pcard:set_edition(card.edition, true)
end
  end
  end,
 add_to_deck = function(self, card, from_debuff)
 	card:set_edition(poll_edition("Sage", 1, true, true, {{name = 'e_foil', weight = 1,}, {name = 'e_holo', weight = 1,}, {name = 'e_polychrome', weight = 1,}, {name = 'e_cry_mosaic', weight = 1,}, {name = 'e_cry_gold', weight = 1,}, {name = 'e_cry_astral', weight = 1,}, }), true)
	 G.GAME.pool_flags.sage_run = true
	end
}
SMODS.Joker{
  key = 'Seraph',
  loc_txt = {
    name = 'SERAPH',
    text = {
      "Gives {C:attention}all played cards{}",
      "this Joker's {C:dark_edition}edition{},",
	  "as well as giving them Holy and a Red Seal.",
	  "Joker's {C:dark_edition}edition{} changes",
	  "before hand is played.",
	  "{C:dark_edition,s:0.75}Andra, I'm tired..."
    }
  },
  -- Extra is empty, because it only happens once. If you wanted to copy multiple cards, you'd need to restructure the code and add a for loop or something.
  yes_pool_flag = 'Sage_run', 
 config = {extra = {}},
  rarity = "cry_exotic",
  atlas = 'Galaxia',
  pos = {x = 6, y = 0},
  cost = 40,
  calculate = function(self, card, context)
   if context.before and context.main_eval then
   card:set_edition(poll_edition("SERAPH", 1, true, true, {{name = 'e_foil', weight = 1,}, {name = 'e_holo', weight = 1,}, {name = 'e_polychrome', weight = 1,}, {name = 'e_cry_mosaic', weight = 1,}, {name = 'e_cry_gold', weight = 1,}, {name = 'e_cry_astral', weight = 1,}, }), true)
	for _, pcard in ipairs(context.full_hand) do

   pcard:set_edition(card.edition, true)
   pcard:set_ability(G.P_CENTERS["m_glx_holy"])
   pcard:set_seal("Red")
end
  end
  end,
add_to_deck = function(self, card, from_debuff)
	card:set_edition(poll_edition("SERAPH", 1, true, true, {{name = 'e_foil', weight = 1,}, {name = 'e_holo', weight = 1,}, {name = 'e_polychrome', weight = 1,}, {name = 'e_cry_mosaic', weight = 1,}, {name = 'e_cry_gold', weight = 1,}, {name = 'e_cry_astral', weight = 1,}, }), true)
	
	end
}
