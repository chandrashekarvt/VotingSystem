import dbm
import json
from operator import le, rshift
from urllib import request
from flask import Flask, jsonify, request
import mysql.connector

mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="thyagarajan9980",
  database="dbms"
)


def getLeaders():
    mycursor = mydb.cursor()
    mycursor.execute("select id, first_name, last_name, dept_name from leaders join departments on leaders.department_id = departments.dept_id")
    myresult = mycursor.fetchall()
    return myresult


def getUsers():
    mycursor = mydb.cursor()
    mycursor.execute("select * from users")
    myresult = mycursor.fetchall()
    return myresult

def loginUser(username, password):
    mycursor = mydb.cursor()
    query = f"select exists(select * from users where username =  '{username}' and password = '{password}')"
    mycursor.execute(query)
    result = mycursor.fetchone()[0]
    return result



def registerUser(username, email, password):
    mycursor = mydb.cursor()
    val = (username, email, password)
    mycursor.execute("insert into users (username, email, password) values (%s, %s, %s)", val)
    mydb.commit()
    if mycursor.rowcount > 0:
        return True
    return False


def userVote(user_id, leader_id):
    try:
        mycursor = mydb.cursor()
        val = (user_id, leader_id)
        mycursor.execute("insert into votes (user_id, leader_id) values (%s, %s)", val)
        mydb.commit()
        if mycursor.rowcount > 0:
            return jsonify({
                'message': 'Succesfully Voted'
            })
    except:
        return jsonify({
                'message': 'You already voted'
        })



def getAdminDetails():
    cursor = mydb.cursor()
    cursor.callproc('getVoteDetails')
    result = []

    # print out the result
    for res in cursor.stored_results():
       result.append(res.fetchall())
    
    result1 = []
    for i in result[0]:
        print(i)
        a, b = i
        result1.append({
            'user' : a,
            'leader' : b
        })

    return jsonify(result1)






app = Flask(__name__)

@app.route("/leaders")
def leaders():
    result = getLeaders()
    resp = []
    for leader in result:
        a, b, c, d = leader
        resp.append({
            'id' : a,
            'first_name' : b,
            'last_name': c,
            'dept' : d
        })
    return jsonify(resp)

@app.route("/users")
def users():
    result = getUsers()
    resp = []
    for user in result:
        a, b, c, d = user
        resp.append({
            'id' : a,
            'username' : b,
            'email': c,
            'password' : d
        })
    return jsonify(resp)

@app.route("/register", methods = ['POST'])
def register():
    req = request.json 
    username = req['username']
    email = req['email']
    password = req['password']

    if loginUser(username=username, password=password) == 1:
        return jsonify({
            'message' : "Already registered"
        })

    if registerUser(username=username, email=email, password=password):
        return jsonify({
            'message' : "Successfull"
        })
    return jsonify({
        'message' : "Unsuccessful"
    })

@app.route("/login", methods = ['POST'])
def login():
    req = request.json 
    username = req['username']
    password = req['password']

    if loginUser(username=username, password=password) == 1:
        return jsonify({
            'message' : "Successful"
        })

    return jsonify({
            'message' : "Unsuccessful"
    })


@app.route("/vote", methods = ['POST'])
def vote():
    req = request.json
    user_id = req['user_id']
    leader_id = req['leader_id']
    return userVote(user_id=user_id, leader_id=leader_id)

@app.route("/adminDetails")
def adminDet():
    return getAdminDetails()
    


if __name__ == '__main__':
    app.run(debug=True)