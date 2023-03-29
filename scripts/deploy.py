from brownie import accounts,BlogChain,BlogToken

def main():
    #get_article()
    account1 = accounts.load("ganache")
    account2 = accounts.load("aryan")
    account3 = accounts.load("aryan2")

    #brownie run deploy.py --network ganache
    blogchain=BlogChain.deploy({"from":account1})
    print("Deployed the contract : BlogChain at ",blogchain) 
    #0x9343B2826DC07D3CF0901A19AD7792e509F0015a

    blogtoken= BlogToken.deploy({"from":account1})
    print("Deployed the contract : BlogToken at ",blogtoken)
    #0xEfeEde1AA8d7F1d527C301A851F6E45CBc7132e2

    print('Transfer: ',blogtoken.transfer(account2,10000000,{"from":account1}))
    print('Transfer: ',blogtoken.transfer(account3,10000000,{"from":account1}))

    print('account1 : ',blogtoken.balanceOf(account1,{"from":account1}))
    print('account2 : ',blogtoken.balanceOf(account2,{"from":account1}))
    print('account3 : ',blogtoken.balanceOf(account3,{"from":account1}))