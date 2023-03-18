from brownie import MiracleNew, Greet,accounts,Miracle
import ipfshttpclient

def main():
    #get_article()
    account = accounts.load("ganache")
    miracle= Miracle.deploy({"from":account})
    #miracle = MiracleNew.deploy("Miracle","MRCL",0,{"from":account})
    print(miracle)
    print("Deployed the contract : Miracle!!!")

def deploy():
    account = accounts.load("ganache")
    greet= Greet.deploy({"from":account})
    return greet


def get_article():
    client = ipfshttpclient.connect()  # Connects to: /dns/localhost/tcp/5001/http
    hash=create_doc()
    print(client.cat(hash))

def create_doc():
    client = ipfshttpclient.connect()  # Connects to: /dns/localhost/tcp/5001/http
    res = client.add('test.txt')
    return res['Hash']    