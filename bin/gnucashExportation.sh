#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
bin=${DIR}/../bin
lib=${DIR}/../lib

echo '
{
    "type" : "jdbc",
    "jdbc" : {
        "url" : "jdbc:sqlite:/home/sam/devhome/workingDirectory/scala/gnuCashSaveSqlite3.gnucash",
        "user" : "",
        "password" : "",
        "sql" : "SELECT s.guid AS _id, s.value_num * 1.0 / s.value_denom AS \"split.value\", s.memo AS \"split.memo\", s.action AS \"split.action\", t.guid AS \"transaction.id\", t.description AS \"transaction.description\", t.post_date AS \"transaction.transaction_date\", t.enter_date AS \"transaction.creation_date\", a1.guid AS \"account.id\", a1.name AS \"account.name\", a1.account_type AS \"account.type\", a1.description AS \"account.description\", c.guid AS \"commodity.id\", c.namespace AS \"commodity.namespace\", c.mnemonic AS \"commodity.mnemonic\", c.fullname AS \"commodity.fullname\" FROM ACCOUNTS AS a1 INNER JOIN SPLITS AS s ON s.account_guid = a1.guid INNER JOIN TRANSACTIONS AS t ON s.tx_guid = t.guid INNER JOIN COMMODITIES AS c ON t.currency_guid = c.guid UNION SELECT s.guid AS _id, s.value_num * 1.0 / s.value_denom AS \"split.value\", s.memo AS \"split.memo\", s.action AS \"split.action\", t.guid AS \"transaction.id\", t.description AS \"transaction.description\", t.post_date AS \"transaction.transaction_date\", t.enter_date AS \"transaction.creation_date\", a2.guid AS \"account.id\", a2.name AS \"account.name\", a2.account_type AS \"account.type\", a2.description AS \"account.description\", c.guid AS \"commodity.id\", c.namespace AS \"commodity.namespace\", c.mnemonic AS \"commodity.mnemonic\", c.fullname AS \"commodity.fullname\" FROM ACCOUNTS AS a1 INNER JOIN ACCOUNTS AS a2 ON a1.parent_guid = a2.guid INNER JOIN SPLITS AS s ON s.account_guid = a1.guid INNER JOIN TRANSACTIONS AS t ON s.tx_guid = t.guid INNER JOIN COMMODITIES AS c ON t.currency_guid = c.guid UNION SELECT s.guid AS _id, s.value_num * 1.0 / s.value_denom AS \"split.value\", s.memo AS \"split.memo\", s.action AS \"split.action\", t.guid AS \"transaction.id\", t.description AS \"transaction.description\", t.post_date AS \"transaction.transaction_date\", t.enter_date AS \"transaction.creation_date\", a3.guid AS \"account.id\", a3.name AS \"account.name\", a3.account_type AS \"account.type\", a3.description AS \"account.description\", c.guid AS \"commodity.id\", c.namespace AS \"commodity.namespace\", c.mnemonic AS \"commodity.mnemonic\", c.fullname AS \"commodity.fullname\" FROM ACCOUNTS AS a1 INNER JOIN ACCOUNTS AS a2 ON a1.parent_guid = a2.guid INNER JOIN ACCOUNTS AS a3 ON a2.parent_guid = a3.guid INNER JOIN SPLITS AS s ON s.account_guid = a1.guid INNER JOIN TRANSACTIONS AS t ON s.tx_guid = t.guid INNER JOIN COMMODITIES AS c ON t.currency_guid = c.guid UNION SELECT s.guid AS _id, s.value_num * 1.0 / s.value_denom AS \"split.value\", s.memo AS \"split.memo\", s.action AS \"split.action\", t.guid AS \"transaction.id\", t.description AS \"transaction.description\", t.post_date AS \"transaction.transaction_date\", t.enter_date AS \"transaction.creation_date\", a4.guid AS \"account.id\", a4.name AS \"account.name\", a4.account_type AS \"account.type\", a4.description AS \"account.description\", c.guid AS \"commodity.id\", c.namespace AS \"commodity.namespace\", c.mnemonic AS \"commodity.mnemonic\", c.fullname AS \"commodity.fullname\" FROM ACCOUNTS AS a1 INNER JOIN ACCOUNTS AS a2 ON a1.parent_guid = a2.guid INNER JOIN ACCOUNTS AS a3 ON a2.parent_guid = a3.guid INNER JOIN ACCOUNTS AS a4 ON a3.parent_guid = a4.guid INNER JOIN SPLITS AS s ON s.account_guid = a1.guid INNER JOIN TRANSACTIONS AS t ON s.tx_guid = t.guid INNER JOIN COMMODITIES AS c ON t.currency_guid = c.guid UNION SELECT s.guid AS _id, s.value_num * 1.0 / s.value_denom AS \"split.value\", s.memo AS \"split.memo\", s.action AS \"split.action\", t.guid AS \"transaction.id\", t.description AS \"transaction.description\", t.post_date AS \"transaction.transaction_date\", t.enter_date AS \"transaction.creation_date\", a5.guid AS \"account.id\", a5.name AS \"account.name\", a5.account_type AS \"account.type\", a5.description AS \"account.description\", c.guid AS \"commodity.id\", c.namespace AS \"commodity.namespace\", c.mnemonic AS \"commodity.mnemonic\", c.fullname AS \"commodity.fullname\" FROM ACCOUNTS AS a1 INNER JOIN ACCOUNTS AS a2 ON a1.parent_guid = a2.guid INNER JOIN ACCOUNTS AS a3 ON a2.parent_guid = a3.guid INNER JOIN ACCOUNTS AS a4 ON a3.parent_guid = a4.guid INNER JOIN ACCOUNTS AS a5 ON a4.parent_guid = a5.guid INNER JOIN SPLITS AS s ON s.account_guid = a1.guid INNER JOIN TRANSACTIONS AS t ON s.tx_guid = t.guid INNER JOIN COMMODITIES AS c ON t.currency_guid = c.guid",
        "index" : "gnucash",
        "type" : "transaction",
        "index_settings" : {
            "index" : {
                "number_of_shards" : 1
            }
        },
        "metrics" : {
            "enabled" : true
        },
        "type_mapping": {
            "transaction" : {
                "properties" : {
                  "split":{
                      "type": "object",
                      "properties" : {
                        "value" : {"type" : "float"},
                        "memo" : {"type" : "string", "index" : "analyzed"},
                        "action" : {"type" : "string", "index" : "analyzed"}
                      }
                  },
                  "transaction":{
                      "type": "object",
                      "properties" : {
                        "id" : {"type" : "string", "index" : "not_analyzed"},
                        "description" : {"type" : "string", "index" : "analyzed"},
                        "transaction_date" : {"type" : "date", "format": "YYYYMMddHHmmss"},
                        "creation_date" : {"type" : "date", "format": "YYYYMMddHHmmss"}
                      }
                  },
                  "account":{
                      "type": "object",
                      "properties" : {
                        "id" : {"type" : "string", "index" : "not_analyzed"},
                        "name" : {"type" : "string", "index" : "not_analyzed", "norms" : { "enabled" : false }},
                        "type" : {"type" : "string", "index" : "not_analyzed", "norms" : { "enabled" : false }},
                        "description" : {"type" : "string", "index" : "analyzed"}
                      }
                  },                    
                  "commodity":{
                      "type": "object",
                      "properties" : {
                        "id" : {"type" : "string", "index" : "not_analyzed"},
                        "namespace" : {"type" : "string", "index" : "not_analyzed", "norms" : { "enabled" : false }},
                        "mnemonic" : {"type" : "string", "index" : "not_analyzed", "norms" : { "enabled" : false }},
                        "fullname" : {"type" : "string", "index" : "not_analyzed", "norms" : { "enabled" : false }}
                      }
                  }                     
                }
            }
        }
    }
}
' | java \
    -cp "${lib}/*" \
    -Dlog4j.configurationFile=${bin}/log4j2.xml \
    org.xbib.tools.Runner \
    org.xbib.tools.JDBCImporter

#20150223230000
#YYYYMMddHHmmss
