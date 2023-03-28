from brownie import accounts,Miracle,MiracleToken

def main():
    #get_article()
    account1 = accounts.load("ganache")
    account2 = accounts.load("aryan")
    account3 = accounts.load("aryan2")

    #brownie run deploy.py --network ganache
    miracle=Miracle.deploy({"from":account1})
    print("Deployed the contract : Miracle at ",miracle) 
    #0x887dc58eA184F9739344BF9aa1C2deb5935d5763

    token= MiracleToken.deploy({"from":account1})
    print("Deployed the contract : MiracleToken at ",token)
    #0x120D32FF3881652687DBf62d6ffB364445aA0E2f

    print('Transfer: ',token.transfer(account2,10000000,{"from":account1}))
    print('Transfer: ',token.transfer(account3,10000000,{"from":account1}))

    print('account1 : ',token.balanceOf(account1,{"from":account1}))
    print('account2 : ',token.balanceOf(account2,{"from":account1}))
    print('account3 : ',token.balanceOf(account3,{"from":account1}))