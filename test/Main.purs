module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)

import Data.Maybe (Maybe(..))

import Test.Assert (assert)

import Node.Buffer (size, toString)
import Node.Encoding (Encoding(UTF8))

import Node.Datagram (SocketType(..), createSocket, bindSocket, onListening, onClose, onMessage, send, sendString, address, close)

runServer :: Effect Unit
runServer = do
  server <- createSocket UDPv4 Nothing

  onListening server $ do
    addr <- address server
    log $ "Server listening on " <> addr.address <> " : " <> (show addr.port)
    runClient addr.port addr.address

  onMessage server \msg from -> do
    msgStr <- toString UTF8 msg
    len <- size msg
    log $ "[SERVER] Received " <> (show len) <> " bytes from " <> from.address <> ":" <> (show from.port) <> " - " <> msgStr
    send server msg Nothing Nothing from.port from.address (Just $ close server)

  onClose server $ log "[SERVER] Socket closed"

  bindSocket server Nothing Nothing

runClient :: Int -> String -> Effect Unit
runClient serverPort serverAddr = do
  client <- createSocket UDPv4 Nothing

  let sentMessage = "Hello World"

  onMessage client \recvMsg from -> do
    recvMsgStr <- toString UTF8 recvMsg
    len <- size recvMsg
    log $ "[CLIENT] Received " <> (show len) <> " bytes from " <> from.address <> ":" <> (show from.port) <> " - " <> recvMsgStr
    assert $ sentMessage == recvMsgStr
    close client

  onClose client $ log "[CLIENT] Socket closed"

  sendString client sentMessage serverPort serverAddr Nothing

main :: Effect Unit
main = runServer
