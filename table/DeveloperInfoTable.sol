pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./Table.sol";

contract DeveloperInfoTable {
    event CreateResult(int256 count);
    event InsertResult(int256 count);
    event UpdateResult(int256 count);
    event RemoveResult(int256 count);

    TableFactory tableFactory;
    string constant TABLE_NAME = "t_developer_info";
    constructor() public {
        tableFactory = TableFactory(0x1001); //The fixed address is 0x1001 for TableFactory
        // the parameters of createTable are tableName,keyField,"vlaueFiled1,vlaueFiled2,vlaueFiled3,..."
        tableFactory.createTable(TABLE_NAME, "developer_address", "developer_id,developer_name");
    }

    function insert(string memory developer_address, string memory developer_id, string memory developer_name) public returns (int256)
    {
        Table table = tableFactory.openTable(TABLE_NAME);
        require(table != address(0x0), "Table not exist");

        Entry entry = table.newEntry();
        entry.set("developer_address", developer_address);
        entry.set("developer_id", developer_id);
        entry.set("developer_name", developer_name);

        int256 count = table.insert(developer_address, entry);
        emit InsertResult(count);

        return count;
    }

    function select(string memory developer_address) public view returns (string[] memory, string[] memory, string[] memory)
    {
        Table table = tableFactory.openTable(TABLE_NAME);
        require(table != address(0x0), "Table not exist");

        Condition condition = table.newCondition();

        Entries entries = table.select(developer_address, condition);
        string[] memory developer_address_bytes_list = new string[](
            uint256(entries.size())
        );
        string[] memory developer_id_bytes_list = new string[](
            uint256(entries.size())
        );
        string[] memory developer_name_bytes_list = new string[](
            uint256(entries.size())
        );

        for (int256 i = 0; i < entries.size(); ++i) {
            Entry entry = entries.get(i);

            developer_address_bytes_list[uint256(i)] = entry.getString("developer_address");
            developer_id_bytes_list[uint256(i)] = entry.getString("developer_id");
            developer_name_bytes_list[uint256(i)] = entry.getString("developer_name");
        }

        return (developer_address_bytes_list, developer_id_bytes_list, developer_name_bytes_list);
    }

    function update(string memory developer_address, string memory developer_id, string memory developer_name) public returns (int256)
    {
        Table table = tableFactory.openTable(TABLE_NAME);
        require(table != address(0x0), "Table not exist");

        Entry entry = table.newEntry();
        entry.set("developer_id", developer_id);
        entry.set("developer_name", developer_name);

        Condition condition = table.newCondition();
        condition.EQ("developer_address", developer_address);

        int256 count = table.update(developer_address, entry, condition);
        emit UpdateResult(count);

        return count;
    }

    function remove(string memory developer_address) public returns (int256) {
        Table table = tableFactory.openTable(TABLE_NAME);
        require(table != address(0x0), "Table not exist");

        Condition condition = table.newCondition();
        condition.EQ("developer_address", developer_address);

        int256 count = table.remove(developer_address, condition);
        emit RemoveResult(count);

        return count;
    }
}
