pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./Table.sol";

contract MeterRegisterInfoTable {
    event CreateResult(int256 count);
    event InsertResult(int256 count);
    event UpdateResult(int256 count);
    event RemoveResult(int256 count);

    TableFactory tableFactory;
    string constant TABLE_NAME = "t_meter_register_info";
    constructor() public {
        tableFactory = TableFactory(0x1001); //The fixed address is 0x1001 for TableFactory
        // the parameters of createTable are tableName,keyField,"vlaueFiled1,vlaueFiled2,vlaueFiled3,..."
        tableFactory.createTable(TABLE_NAME, "meter_address", "meter_id, meter_info_hash");
    }

    function register(string memory meter_address, string memory meter_id, string memory meter_info_hash) public returns (int256)
    {
        Table table = tableFactory.openTable(TABLE_NAME);
        require(table != address(0x0), "Table not exist");

        Condition condition = table.newCondition();
        Entries entries = table.select(meter_address, condition);
        require(entries.size() == 0, "Meter is registered");
        int256 count = insert(meter_address, meter_id, meter_info_hash);

        return count;
    }

    function insert(string memory meter_address, string memory meter_id, string memory meter_info_hash) public returns (int256)
    {
        Table table = tableFactory.openTable(TABLE_NAME);
        require(table != address(0x0), "Table not exist");

        Entry entry = table.newEntry();
        entry.set("meter_address", meter_address);
        entry.set("meter_id", meter_id);
        entry.set("meter_info_hash", meter_info_hash);

        int256 count = table.insert(meter_address, entry);
        emit InsertResult(count);

        return count;
    }

    function select(string memory meter_address) public view returns (string[] memory, string[] memory, string[] memory)
    {
        Table table = tableFactory.openTable(TABLE_NAME);
        require(table != address(0x0), "Table not exist");

        Condition condition = table.newCondition();

        Entries entries = table.select(meter_address, condition);
        string[] memory meter_address_bytes_list = new string[](
            uint256(entries.size())
        );
        string[] memory meter_id_bytes_list = new string[](
            uint256(entries.size())
        );
        string[] memory meter_info_hash_bytes_list = new string[](
            uint256(entries.size())
        );

        for (int256 i = 0; i < entries.size(); ++i) {
            Entry entry = entries.get(i);

            meter_address_bytes_list[uint256(i)] = entry.getString("meter_address");
            meter_id_bytes_list[uint256(i)] = entry.getString("meter_id");
            meter_info_hash_bytes_list[uint256(i)] = entry.getString("meter_info_hash");
        }

        return (meter_address_bytes_list, meter_id_bytes_list, meter_info_hash_bytes_list);
    }

    function update(string memory meter_address, string memory meter_id, string memory meter_info_hash) public returns (int256)
    {
        Table table = tableFactory.openTable(TABLE_NAME);
        require(table != address(0x0), "Table not exist");

        Entry entry = table.newEntry();
        entry.set("meter_id", meter_id);
        entry.set("meter_info_hash", meter_info_hash);

        Condition condition = table.newCondition();
        condition.EQ("meter_address", meter_address);

        int256 count = table.update(meter_address, entry, condition);
        emit UpdateResult(count);

        return count;
    }

    function remove(string memory meter_address) public returns (int256) {
        Table table = tableFactory.openTable(TABLE_NAME);
        require(table != address(0x0), "Table not exist");

        Condition condition = table.newCondition();
        condition.EQ("meter_address", meter_address);

        int256 count = table.remove(meter_address, condition);
        emit RemoveResult(count);

        return count;
    }
}
