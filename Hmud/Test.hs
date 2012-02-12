module Hmud.Test where

import Test.Hspec.HUnit
import Test.Hspec
import Test.HUnit
import Data.Maybe (fromJust)
import Data.Either.Unwrap

import Hmud.World
import Hmud.Character
import Hmud.Room
import Hmud.TestData

player0 = Character
  { charName = "player0"
  , charRace = Human
  , charRole = Fool
  , charGender = Female
  , charLevel = 1
  }

emptyWorld = World { worldRooms = [] }

specs :: Specs
specs = descriptions
  [ describe "insertCharacterToRoom"
    [ it "returns Nothing when there is no such room in the world"
        (either (const True) (const False) $ insertCharacterToRoom player0 "what where?" emptyWorld)
    , it "returns Nothing when there is no such room in the world"
        (either (const True) (const False) $ insertCharacterToRoom player0 "what where?" world)
    , it "returns the world where the player is in the desired room on success"
        ((do
          w <- insertCharacterToRoom player0 "The Black Unicorn" world
          r <- findRoom "The Black Unicorn" w
          findCharacter "player0" r
        ) == Right player0)
    , it "works with abbreviated room name"
        ((do
          w <- insertCharacterToRoom player0 "The Bl" world
          r <- findRoom "The Black Unicorn" w
          findCharacter "player0" r
        ) == Right player0)
    ]

  , describe "gotoFromTo"
    [ it "returns Nothing if there is no such *from* room"
        (either (const True) (const False) $ gotoFromTo "player0" "what where?" "The Black Unicorn" world)
    , it "returns Nothing if there is no such *to* room"
        (either (const True) (const False) $ gotoFromTo "player0" "The Black Unicorn" "what where?" world)
    , it "returns Nothing if there is no such character in the *from* room"
        (either (const True) (const False) $ gotoFromTo "slayer0" "The Black Unicorn" "Town Square" world)
    , it "works when everything is fine"
      (TestCase $ do
                  let w2 = fromRight $ insertCharacterToRoom player0 "The Black Unicorn" world
                  let w3 = fromRight $ gotoFromTo "player0" "The Black Unicorn" "Town Square" w2
                  let fromRoom = fromRight $ findRoom "The Black Unicorn" w3
                  let toRoom   = fromRight $ findRoom "Town Square" w3
                  assertBool "player is no longer in *fromRoom*" $ isLeft (findCharacter "player0" fromRoom)
                  assertEqual "player is now in *toRoom*" (Right player0) (findCharacter "player0" toRoom)
      )
    , it "works with abbreviated names"
      (TestCase $ do
                  let w2 = fromRight $ insertCharacterToRoom player0 "The Black" world
                  let w3 = fromRight $ gotoFromTo "pl" "Th" "To" w2
                  let fromRoom = fromRight $ findRoom "The Blac" w3
                  let toRoom   = fromRight $ findRoom "Tow" w3
                  assertBool "player is no longer in *fromRoom*" $ isLeft (findCharacter "player" fromRoom)
                  assertEqual "player is now in *toRoom*" (Right player0) (findCharacter "play" toRoom)
      )
    ]
  ]

main = hspec specs