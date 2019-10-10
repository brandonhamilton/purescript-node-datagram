-- | This module defines low-level bindings to the Node dgram module.

module Node.Datagram 
  ( Socket

  , SocketType(..)
  , SocketInfo

  , createSocket
  , bindSocket
  , close

  , send
  , sendString

  , onMessage
  , onListening
  , onClose
  , onError
  
  , address
  , setBroadcast
  , setMulticastLoopback
  , setTTL
  , setMulticastTTL

  , addMembership
  , dropMembership

  , unref
  , ref
  ) where

import Prelude (Unit)

import Effect
import Effect.Exception (Error)

import Data.Nullable (Nullable, toNullable)
import Data.Maybe (Maybe)

import Node.Buffer (Buffer)

-- | The type of a Datagram socket object

foreign import data Socket :: Type

-- | Type of Datagram socket
data SocketType = UDPv4 | UDPv6

-- | Socket address information
type SocketInfo =
  { address :: String
  , family  :: String
  , port    :: Int
  }

-- | Creates a Socket data structure
createSocket :: SocketType -> Maybe Boolean -> Effect Socket
createSocket UDPv4 reuseAddr = createSocketImpl "udp4" (toNullable reuseAddr)
createSocket UDPv6 reuseAddr = createSocketImpl "udp6" (toNullable reuseAddr)
foreign import createSocketImpl :: String -> Nullable Boolean -> Effect Socket

-- | Listen for datagram messages. A bound datagram socket keeps the Node.js process running to receive datagram messages
bindSocket :: Socket -> Maybe Int -> Maybe String -> Effect Unit
bindSocket socket port addr = bindImpl socket (toNullable port) (toNullable addr)
foreign import bindImpl :: Socket -> Nullable Int -> Nullable String -> Effect Unit

-- | Close the underlying socket and stop listening for data on it
foreign import close :: Socket -> Effect Unit

-- | Function that will be called when a new datagram is available on a socket
foreign import onMessage :: Socket -> (Buffer -> SocketInfo -> Effect Unit) -> Effect Unit

-- | Function that will be called whenever a socket begins listening for datagram messages
foreign import onListening :: Socket -> Effect Unit -> Effect Unit

-- | Function that will be called after a socket is closed with `close`
foreign import onClose :: Socket -> Effect Unit -> Effect Unit

-- | Function that will be called whenever any error occurs
foreign import onError :: Socket -> (Error -> Effect Unit) -> Effect Unit

-- | Broadcasts a datagram on the socket
send :: Socket -> Buffer -> Maybe Int -> Maybe Int -> Int -> String -> Maybe (Effect Unit) -> Effect Unit
send socket buffer offset len port addr callback = sendImpl socket buffer (toNullable offset) (toNullable len) port addr (toNullable callback)
foreign import sendImpl :: Socket -> Buffer -> Nullable Int -> Nullable Int -> Int -> String -> Nullable (Effect Unit) -> Effect Unit

-- | Broadcasts a datagram on the socket
sendString :: Socket -> String -> Int -> String -> Maybe (Effect Unit) -> Effect Unit
sendString socket str port addr callback = sendStringImpl socket str port addr (toNullable callback)
foreign import sendStringImpl :: Socket -> String -> Int -> String -> Nullable (Effect Unit) -> Effect Unit

-- | Return the address information for a socket
foreign import address :: Socket -> Effect SocketInfo

-- | Sets or clears the SO_BROADCAST socket option
foreign import setBroadcast :: Socket -> Boolean -> Effect Unit

-- | Sets or clears the IP_MULTICAST_LOOP socket option
foreign import setMulticastLoopback :: Socket -> Boolean -> Effect Unit

-- | Sets the `IP_TTL` socket option
foreign import setTTL :: Socket -> Int -> Effect Unit

-- | Sets the `IP_MULTICAST_TTL` socket option
foreign import setMulticastTTL :: Socket -> Int -> Effect Unit

-- | Tell the kernel to join a multicast group
addMembership :: Socket -> String -> Maybe String -> Effect Unit
addMembership socket multicastAddress multicastInterface = addMembershipImpl socket multicastAddress (toNullable multicastInterface)
foreign import addMembershipImpl :: Socket -> String -> Nullable String -> Effect Unit

-- | Instruct the kernel to leave a multicast group
dropMembership :: Socket -> String -> Maybe String -> Effect Unit
dropMembership socket multicastAddress multicastInterface = dropMembershipImpl socket multicastAddress (toNullable multicastInterface)
foreign import dropMembershipImpl :: Socket -> String -> Nullable String -> Effect Unit

-- | Exclude the socket from the reference counting that keeps the Node.js process active, allowing the process to exit even if the socket is still listening
foreign import unref :: Socket -> Effect Socket

-- | Add the socket back to the reference counting and restore the default behavior
foreign import ref :: Socket -> Effect Socket

