module Hmud.Character where

import Data.List
import Data.Char (toLower)

import Hmud.Describable
import Hmud.Item

data Race = Human | Elven | Dwarf
  deriving (Eq, Show, Enum, Bounded)

data Role = Fool
          | Thief
          | Servant
          | Hunter
          | Peasant
          | Blacksmith
          | Merchant
          | Priest
          | Warrior
          | Knight
          | Wizard
          | Prince
          | King
  deriving (Eq, Show, Enum, Bounded)

genderedRoles =
  --              Male           Female
  [ (Fool,       ("Fool",        "Fool"))
  , (Thief,      ("Thief",       "Thief"))
  , (Servant,    ("Servant",     "Servant"))
  , (Hunter,     ("Hunter",      "Hunter"))
  , (Peasant,    ("Peasant",     "Peasant"))
  , (Blacksmith, ("Blacksmith",  "Blacksmith"))
  , (Merchant,   ("Merchant",    "Merchant"))
  , (Priest,     ("Priest",      "Priestess"))
  , (Warrior,    ("Warrior",     "Warrior"))
  , (Knight,     ("Knight",      "Knight"))
  , (Wizard,     ("Wizard",      "Wizard") )
  , (Prince,     ("Prince",      "Princess"))
  , (King,       ("King",        "Queen"))
  ]

data Gender = Male | Female
  deriving (Eq, Show, Enum, Bounded)

data Character = Character
  { charName :: String
  , charRace :: Race
  , charRole :: Role
  , charGender :: Gender
  , charLevel :: Int
  , charInventory :: [Item]
  }
  deriving Eq

instance Describable Character where
  name = charName
  describe char = "a level " ++ (show $ charLevel char)
                       ++ " " ++ (map toLower $ show $ charGender char)
                       ++ " " ++ (map toLower $ show $ charRace char)
                       ++ " " ++ role
    where
      role = case Data.List.lookup (charRole char) genderedRoles of
        Nothing                             -> "Nobody"
        Just (maleRoleName, femaleRoleName) -> if (charGender char == Male )
                                               then maleRoleName
                                               else femaleRoleName

instance Show Character where
  show = charName

giveItemToCharacter item char = char { charInventory = item : (charInventory char) }

characterFindItem :: String -> Character -> Either String Item
characterFindItem itName char =
  maybe
    (Left $ "no item " ++ itName ++ " in " ++ (name char) ++ "'s inventory")
    Right
    (find (\item -> itName `isPrefixOf` (name item)) (charInventory char))
