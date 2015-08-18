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
        "sql" : "SELECT s.guid AS _id, s.value_num * 1.0 / s.value_denom AS \"split.value\", s.memo AS \"split.memo\", s.action AS \"split.action\", t.guid AS \"transaction.id\", t.description AS \"transaction.description\", t.post_date AS \"transaction.transaction_date\", t.enter_date AS \"transaction.creation_date\", a1.guid AS \"main_account.id\", a1.name AS \"main_account.name\", a1.account_type AS \"main_account.type\", a1.description AS \"main_account.description\", a1.code AS \"main_account.code\", a1.guid AS \"sub_accounts.id\", a1.name AS \"sub_accounts.name\", a1.account_type AS \"sub_accounts.type\", a1.code AS \"sub_accounts.code\", a2.guid AS \"sub_accounts.id\", a2.name AS \"sub_accounts.name\", a2.account_type AS \"sub_accounts.type\", a2.code AS \"sub_accounts.code\", a3.guid AS \"sub_accounts.id\", a3.name AS \"sub_accounts.name\", a3.account_type AS \"sub_accounts.type\", a3.code AS \"sub_accounts.code\", a4.guid AS \"sub_accounts.id\", a4.name AS \"sub_accounts.name\", a4.account_type AS \"sub_accounts.type\", a4.code AS \"sub_accounts.code\", a5.guid AS \"sub_accounts.id\", a5.name AS \"sub_accounts.name\", a5.account_type AS \"sub_accounts.type\", a5.code AS \"sub_accounts.code\", c.guid AS \"commodity.id\", c.namespace AS \"commodity.namespace\", c.mnemonic AS \"commodity.mnemonic\", c.fullname AS \"commodity.fullname\" FROM ACCOUNTS AS a1 LEFT OUTER JOIN ACCOUNTS AS a2 ON a1.parent_guid = a2.guid LEFT OUTER JOIN ACCOUNTS AS a3 ON a2.parent_guid = a3.guid LEFT OUTER JOIN ACCOUNTS AS a4 ON a3.parent_guid = a4.guid LEFT OUTER JOIN ACCOUNTS AS a5 ON a4.parent_guid = a5.guid INNER JOIN SPLITS AS s ON s.account_guid = a1.guid INNER JOIN TRANSACTIONS AS t ON s.tx_guid = t.guid INNER JOIN COMMODITIES AS c ON t.currency_guid = c.guid",
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
                  "main_account":{
                      "type": "object",
                      "properties" : {
                        "id" : {"type" : "string", "index" : "not_analyzed"},
                        "name" : {"type" : "string", "index" : "not_analyzed", "norms" : { "enabled" : false }},
                        "type" : {"type" : "string", "index" : "not_analyzed", "norms" : { "enabled" : false }},
                        "description" : {"type" : "string", "index" : "analyzed"},
                        "code" : {"type" : "string", "index" : "not_analyzed", "norms" : { "enabled" : false }}
                      }
                  },
                  "sub_accounts":{
                      "type": "object",
                      "properties" : {
                        "id" : {"type" : "string", "index" : "not_analyzed"},
                        "name" : {"type" : "string", "index" : "not_analyzed", "norms" : { "enabled" : false }},
                        "type" : {"type" : "string", "index" : "not_analyzed", "norms" : { "enabled" : false }},
                        "code" : {"type" : "string", "index" : "not_analyzed", "norms" : { "enabled" : false }}
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
