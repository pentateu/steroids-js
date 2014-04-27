// Generated by CoffeeScript 1.7.1
window.DataController = (function() {
  function DataController() {}

  document.addEventListener("deviceready", function() {
    return steroids.navigationBar.show({
      title: "data"
    });
  });

  DataController.testSteroidsCommonSave = function() {
    var contact;
    return contact = {
      name: 'John',
      age: 31
    };
  };

  DataController.testStartSteroidsCommon = function() {
    var contact;
    contact = {
      name: 'John',
      age: 31
    };
    return steroids.data.steroids.define({
      name: 'Contacts',
      fields: {
        name: 'string',
        age: 'number'
      }
    }, {
      onSuccess: function() {
        return alert("data.steroids.define -> onSuccess ");
      },
      onFailure: function() {
        return alert("data.steroids.define -> onFailure ");
      }
    });
  };

  DataController.testPersistenceOverrideNativeSQL = function() {
    if (!window.sqlitePlugin.openDatabase) {
      alert("SQLitePlugin not loaded");
      return;
    }
    window.openDatabase = window.sqlitePlugin.openDatabase;
    return alert("done");
  };

  DataController.testPersistenceJSDropTestDB = function() {
    var persistencedb;
    persistencedb = new steroids.data.SQLiteDB("persistencedb");
    return persistencedb.dropTable("Task", {
      onSuccess: function() {
        return alert("dropped");
      },
      onFailure: function() {
        return alert("could not drop");
      }
    });
  };

  DataController.getTask = function() {
    var Task;
    Task = persistence.define('Task', {
      name: "TEXT",
      description: "TEXT",
      done: "BOOL"
    });
    return Task;
  };

  DataController.testPersistenceJSDefineTask = function() {
    this.getTask();
    return persistence.schemaSync(function() {
      return alert("defined");
    });
  };

  DataController.testPersistenceJSConfigure = function() {
    persistence.store.websql.config(persistence, 'persistencedb', 'A database description', 5 * 1024 * 1024);
    return alert("configured");
  };

  DataController.testPersistenceJSInsertTask = function() {
    var Task, t;
    Task = this.getTask();
    t = new Task();
    t.name = "taskname";
    t.description = "taskdescription";
    t.done = false;
    persistence.add(t);
    return persistence.flush(function() {
      return alert("inserted");
    });
  };

  DataController.testPersistenceJSListAllTasks = function() {
    var Task;
    Task = this.getTask();
    return Task.all().list(function(tasks) {
      steroids.debug(tasks);
      return alert("see console debug");
    });
  };

  DataController.testSQLiteDB = function() {
    var sqlitedb;
    sqlitedb = new steroids.data.SQLiteDB("testdb");
    if (sqlitedb.databaseName === "testdb") {
      return alert("ok");
    } else {
      return alert("not ok");
    }
  };

  DataController.testSQLiteDBCreateTable = function() {
    var sqlitedb;
    sqlitedb = new steroids.data.SQLiteDB("testdb");
    return sqlitedb.createTable({
      name: "cars",
      columns: {
        car_id: "integer",
        name: "text",
        description: "text",
        img: "blob",
        price: "real"
      }
    }, {
      onSuccess: function() {
        return alert("Created table");
      },
      onFailure: function() {
        return alert("Failed creating table");
      }
    });
  };

  DataController.testSQLiteDBDropTable = function() {
    var testdb;
    testdb = new steroids.data.SQLiteDB("testdb");
    return testdb.dropTable("cars", {
      onSuccess: function() {
        return alert("dropped");
      },
      onFailure: function() {
        return alert("drop failed");
      }
    });
  };

  DataController.testSQLiteDBexecute = function() {
    var testdb;
    testdb = new steroids.data.SQLiteDB("testdb");
    testdb.execute("INSERT INTO cars (car_id, name, description, img, price) VALUES (1, 'toyota', 'good car', 'somebase64image', 2.50)", {
      onSuccess: function(rows, res, tx) {
        return steroids.debug(res);
      },
      onFailure: (function(_this) {
        return function(err) {
          return alert(err.message);
        };
      })(this)
    });
    return testdb.execute("SELECT COUNT(*) FROM cars", {
      onSuccess: (function(_this) {
        return function(rows, res, tx) {
          return alert("COUNT = " + rows[0]['COUNT(*)']);
        };
      })(this),
      onFailure: (function(_this) {
        return function(err) {
          return alert(err.message);
        };
      })(this)
    });
  };

  DataController.testTouchDBOnReadyExisting = function() {
    var touchdb;
    touchdb = new steroids.data.TouchDB({
      name: "testdb"
    });
    return touchdb.on('ready', (function(_this) {
      return function() {
        var samedb;
        alert("first 'testdb' ready");
        samedb = new steroids.data.TouchDB({
          name: "testdb"
        });
        return samedb.on('ready', function() {
          return alert("second 'testdb' ready");
        });
      };
    })(this));
  };

  DataController.testTouchDBOnChange = function() {
    var touchdb;
    touchdb = new steroids.data.TouchDB({
      name: "testdb"
    });
    return touchdb.on('change', (function(_this) {
      return function() {
        return alert('changed, always fired when set -- needs more thinking, cuz is currently required for ng-touchdb');
      };
    })(this));
  };

  DataController.testRSSFetch = function() {
    var lol;
    lol = new steroids.data.RSS("url");
    return console.log(lol);
  };

  return DataController;

})();
