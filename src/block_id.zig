const BlockId = struct {
    blockNnumber: i32,
    fileName: []const u8,

    fn fileName(self: @This()) []const u8 {
        return self.fileName;
    }

    fn blockNumber(self: @This()) i32 {
        return self.blockNumber;
    }

    fn toString(self: @This()) []const u8 {
        return "[file " + self.fileName + ", block " + self.blockNumber + "]";
    }
};
