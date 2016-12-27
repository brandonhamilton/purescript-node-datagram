-- | This module defines low-level bindings to the Node dgram module.

module Node.Datagram 
  ( Socket
  , DATAGRAM

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

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error())

import Data.Nullable (Nullable, toNullable)
import Data.Maybe (Maybe)

import Node.Buffer (Buffer)

-- | The type of a Datagram socket object

foreign import data Socket :: *

-- | The effect associated with using the Datagram module.

foreign import data DATAGRAM :: !

-- | Type of Datagram socket
data SocketType = UDPv4 | UDPv6

-- | Socket address information
type SocketInfo =
  { address :: String
  , family  :: String
  , port    :: Int
  }

-- | Creates a Socket data structure
createSocket :: forall eff. SocketType -> Maybe Boolean -> Eff (dgram :: DATAGRAM | eff) Socket
createSocket UDPv4 reuseAddr = createSocketImpl "udp4" (toNullable reuseAddr)
createSocket UDPv6 reuseAddr = createSocketImpl "udp6" (toNullable reuseAddr)
foreign import createSocketImpl :: forall eff. String -> Nullable Boolean -> Eff (dgram :: DATAGRAM | eff) Socket

-- | Listen for datagram messages. A bound datagram socket keeps the Node.js process running to receive datagram messages
bindSocket :: forall eff. Socket -> Maybe Int -> Maybe String -> Eff (dgram :: DATAGRAM | eff) Unit
bindSocket socket port addr = bindImpl socket (toNullable port) (toNullable addr)
foreign import bindImpl :: forall eff. Socket -> Nullable Int -> Nullable String -> Eff (dgram :: DATAGRAM | eff) Unit

-- | Close the underlying socket and stop listening for data on it
foreign import close :: forall eff. Socket -> Eff (dgram :: DATAGRAM | eff) Unit

-- | Function that will be called when a new datagram is available on a socket
foreign import onMessage :: forall eff. Socket -> (Buffer -> SocketInfo -> Eff eff Unit) -> Eff eff Unit

-- | Function that will be called whenever a socket begins listening for datagram messages
foreign import onListening :: forall eff. Socket -> Eff eff Unit -> Eff eff Unit

-- | Function that will be called after a socket is closed with `close`
foreign import onClose :: forall eff. Socket -> Eff eff Unit -> Eff eff Unit

-- | Function that will be called whenever any error occurs
foreign import onError :: forall eff. Socket -> (Error -> Eff eff Unit) -> Eff eff Unit

-- | Broadcasts a datagram on the socket
send :: forall eff. Socket -> Buffer -> Maybe Int -> Maybe Int -> Int -> String -> Maybe (Eff eff Unit) -> Eff eff Unit
send socket buffer offset len port addr callback = sendImpl socket buffer (toNullable offset) (toNullable len) port addr (toNullable callback)
foreign import sendImpl :: forall eff. Socket -> Buffer -> Nullable Int -> Nullable Int -> Int -> String -> Nullable (Eff eff Unit) -> Eff eff Unit

-- | Broadcasts a datagram on the socket
sendString :: forall eff. Socket -> String -> Int -> String -> Maybe (Eff eff Unit) -> Eff eff Unit
sendString socket str port addr callback = sendStringImpl socket str port addr (toNullable callback)
foreign import sendStringImpl :: forall eff. Socket -> String -> Int -> String -> Nullable (Eff eff Unit) -> Eff eff Unit

-- | Return the address information for a socket
foreign import address :: forall eff. Socket -> Eff (dgram :: DATAGRAM | eff) SocketInfo

-- | Sets or clears the SO_BROADCAST socket option
foreign import setBroadcast :: forall eff. Socket -> Boolean -> Eff (dgram :: DATAGRAM | eff) Unit

-- | Sets or clears the IP_MULTICAST_LOOP socket option
foreign import setMulticastLoopback :: forall eff. Socket -> Boolean -> Eff (dgram :: DATAGRAM | eff) Unit

-- | Sets the `IP_TTL` socket option
foreign import setTTL :: forall eff. Socket -> Int -> Eff (dgram :: DATAGRAM | eff) Unit

-- | Sets the `IP_MULTICAST_TTL` socket option
foreign import setMulticastTTL :: forall eff. Socket -> Int -> Eff (dgram :: DATAGRAM | eff) Unit

-- | Tell the kernel to join a multicast group
addMembership :: forall eff. Socket -> String -> Maybe String -> Eff (dgram :: DATAGRAM | eff) Unit
addMembership socket multicastAddress multicastInterface = addMembershipImpl socket multicastAddress (toNullable multicastInterface)
foreign import addMembershipImpl :: forall eff. Socket -> String -> Nullable String -> Eff (dgram :: DATAGRAM | eff) Unit

-- | Instruct the kernel to leave a multicast group
dropMembership :: forall eff. Socket -> String -> Maybe String -> Eff (dgram :: DATAGRAM | eff) Unit
dropMembership socket multicastAddress multicastInterface = dropMembershipImpl socket multicastAddress (toNullable multicastInterface)
foreign import dropMembershipImpl :: forall eff. Socket -> String -> Nullable String -> Eff (dgram :: DATAGRAM | eff) Unit

-- | Exclude the socket from the reference counting that keeps the Node.js process active, allowing the process to exit even if the socket is still listening
foreign import unref :: forall eff. Socket -> Eff (dgram :: DATAGRAM | eff) Socket

-- | Add the socket back to the reference counting and restore the default behavior
foreign import ref :: forall eff. Socket -> Eff (dgram :: DATAGRAM | eff) Socket

