"use strict";

import dgram from "dgram";

export function createSocketImpl (type) {
  return function (reuseAddr) {
    return function () {
      if (reuseAddr == null) {
        return dgram.createSocket(type);
      } else {
        return dgram.createSocket({ type: type, reuseAddr: reuseAddr });
      }
    };
  };
};

export function bindImpl (socket) {
  return function (port) {
    return function (address) {
      return function () {
        return socket.bind(port, address);
      };
    };
  };
};

export function onMessage (socket) {
  return function (callback) {
    return function () {
      socket.on("message", function (msg, from) {
        callback(msg)(from)();
      });
    };
  };
};

export function onListening (socket) {
  return function (callback) {
    return function () {
      socket.on("listening", callback);
    };
  };
};

export function onClose (socket) {
  return function (callback) {
    return function () {
      socket.on("close", callback);
    };
  };
};

export function onError (socket) {
  return function (callback) {
    return function () {
      socket.on("error", function (err) {
        callback(err)();
      });
    };
  };
};

export function address (socket) {
  return function () {
    return socket.address();
  };
};

export function sendImpl (socket) {
  return function (msg) {
    return function (offset) {
      return function (length) {
        return function (port) {
          return function (address) {
            return function (callback) {
              return function () {
                if (offset == null || length == null) {
                  return socket.send(msg, port, address, callback);
                } else {
                  return socket.send(msg, offset, length, port, address, callback);
                }
              };
            };
          };
        };
      };
    };
  };
};

export function sendStringImpl (socket) {
  return function (msg) {
    return function (port) {
      return function (address) {
        return function (callback) {
          return function () {
            return socket.send(msg, port, address, callback);
          };
        };
      };
    };
  };
};

export function close (socket) {
  return function () {
    return socket.close();
  };
};

export function setBroadcast (socket) {
  return function (flag) {
    return function () {
      return socket.setBroadcast(flag);
    };
  };
};

export function setMulticastLoopback (socket) {
  return function (flag) {
    return function () {
      return socket.setMulticastLoopback(flag);
    };
  };
};

export function setTTL (socket) {
  return function (ttl) {
    return function () {
      return socket.setTTL(ttl);
    };
  };
};

export function setMulticastTTL (socket) {
  return function (ttl) {
    return function () {
      return socket.setMulticastTTL(ttl);
    };
  };
};

export function addMembershipImpl (socket) {
  return function (multicastAddress) {
    return function (multicastInterface) {
      return function () {
        return socket.addMembership(multicastAddress, multicastInterface);
      };
    };
  };
};

export function dropMembershipImpl (socket) {
  return function (multicastAddress) {
    return function (multicastInterface) {
      return function () {
        return socket.dropMembership(multicastAddress, multicastInterface);
      };
    };
  };
};

export function ref (socket) {
  return function () {
    return socket.ref();
  };
};

export function unref (socket) {
  return function () {
    return socket.ref();
  };
};
