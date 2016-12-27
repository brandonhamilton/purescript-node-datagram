"use strict";

var dgram = require("dgram");

exports.createSocketImpl = function (type) {
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

exports.bindImpl = function (socket) {
  return function (port) {
    return function (address) {
      return function () {
        return socket.bind(port, address);
      };
    };
  };
};

exports.onMessage = function (socket) {
  return function (callback) {
    return function () {
      socket.on("message", function (msg, from) {
        callback(msg)(from)();
      });
    };
  };
};

exports.onListening = function (socket) {
  return function (callback) {
    return function () {
      socket.on("listening", callback);
    };
  };
};

exports.onClose = function (socket) {
  return function (callback) {
    return function () {
      socket.on("close", callback);
    };
  };
};

exports.onError = function onError (socket) {
  return function (callback) {
    return function () {
      socket.on("error", function (err) {
        callback(err)();
      });
    };
  };
};

exports.address = function (socket) {
  return function () {
    return socket.address();
  };
};

exports.sendImpl = function (socket) {
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

exports.sendStringImpl = function (socket) {
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

exports.close = function (socket) {
  return function () {
    return socket.close();
  };
};

exports.setBroadcast = function (socket) {
  return function (flag) {
    return function () {
      return socket.setBroadcast(flag);
    };
  };
};

exports.setMulticastLoopback = function (socket) {
  return function (flag) {
    return function () {
      return socket.setMulticastLoopback(flag);
    };
  };
};

exports.setTTL = function (socket) {
  return function (ttl) {
    return function () {
      return socket.setTTL(ttl);
    };
  };
};

exports.setMulticastTTL = function (socket) {
  return function (ttl) {
    return function () {
      return socket.setMulticastTTL(ttl);
    };
  };
};

exports.addMembershipImpl = function (socket) {
  return function (multicastAddress) {
    return function (multicastInterface) {
      return function () {
        return socket.addMembership(multicastAddress, multicastInterface);
      };
    };
  };
};

exports.dropMembershipImpl = function (socket) {
  return function (multicastAddress) {
    return function (multicastInterface) {
      return function () {
        return socket.dropMembership(multicastAddress, multicastInterface);
      };
    };
  };
};

exports.ref = function (socket) {
  return function () {
    return socket.ref();
  };
};

exports.unref = function (socket) {
  return function () {
    return socket.ref();
  };
};
