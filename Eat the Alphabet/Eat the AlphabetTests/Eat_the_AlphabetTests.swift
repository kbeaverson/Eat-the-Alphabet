//
//  Eat_the_AlphabetTests.swift
//  Eat the AlphabetTests
//
//  Created by Kenny Beaverson on 6/1/25.
//

import Foundation
import Testing
import Supabase
@testable import Eat_the_Alphabet


struct Eat_the_AlphabetTests {
    
    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    /** TEST get user access token first*/
    @Test func testConfigs() async throws {
        print("Testing configurations...")
        // test if values SUPABASE_URL is not empty
        #expect(Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String != nil, "SUPABASE_URL should not be nil")
        
    }
    
    @Test func testRegister() async throws {
        
    }
    
    /** TEST follow-up log out test function*/
    /** TEST GROUP Account Repository */

}
