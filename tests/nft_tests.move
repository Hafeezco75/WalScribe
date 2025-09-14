module walscribe::nft_test;

#[test_only]
use sui::url;
use std::string;
use sui::test_scenario::Scenario;


#[test_only]
const UNIQUE: string = 'IKa';


#[test_only]
fun test_mint_to_sender(ts: &mut Scenario) {
    let mut ts = ts::begin();
    let ctx: test_scenario::ctx(mut ts);

    let mut description = 
}
