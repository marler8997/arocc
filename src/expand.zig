const Compilation = @import("Compilation.zig");
const Tokenizer = @import("Tokenizer.zig");
const Token = @import("Tree.zig").Token;

/// Get expanded token source string.
pub fn expandedSlice(comp: *Compilation, tok: Token) []const u8 {
    return expandedSliceExtra(comp, tok, .single_macro_ws);
}

pub fn expandedSliceExtra(comp: *Compilation, tok: Token, macro_ws_handling: enum { single_macro_ws, preserve_macro_ws }) []const u8 {
    if (tok.id.lexeme()) |some| {
        if (!tok.id.allowsDigraphs(comp) and !(tok.id == .macro_ws and macro_ws_handling == .preserve_macro_ws)) return some;
    }
    var tmp_tokenizer = Tokenizer{
        .buf = comp.getSource(tok.loc.id).buf,
        .comp = comp,
        .index = tok.loc.byte_offset,
        .source = .generated,
    };
    if (tok.id == .macro_string) {
        while (true) : (tmp_tokenizer.index += 1) {
            if (tmp_tokenizer.buf[tmp_tokenizer.index] == '>') break;
        }
        return tmp_tokenizer.buf[tok.loc.byte_offset .. tmp_tokenizer.index + 1];
    }
    const res = tmp_tokenizer.next();
    return tmp_tokenizer.buf[res.start..res.end];
}
