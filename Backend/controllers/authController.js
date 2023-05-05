import bcrypt from "bcrypt";
import jwt from "jsonwebtoken"
import User from "../models/user.js"

/*REGISTERING USER */

export const register = async (req, res) => {
    try {
        const {
            firstName,
            lastName,
            email,
            password,
            role
        } = req.body;
        let oldUser = await User.findOne({ email: email });
        if (oldUser) {
            throw new Error("Email already exist");
        }
        const salt = await bcrypt.genSalt(10)
        const passwordHash = await bcrypt.hash(password, salt)

        const newUser = new User({
            firstName,
            lastName,
            email,
            password: passwordHash,
            role
        })
        const savedUser = await newUser.save();
        res.status(201).json(savedUser);
    } catch (err) {
        res.status(500).json({error: err.message});
    }
}

// LOGGING IN 
export const login = async (req, res) => {
    const { email, password } = req.body;
  
    try {
      const user = await User.findOne({ email });
      if (!user) return res.status(400).send("Invalid Email ");
  
      const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) return res.status(400).send("Invalid Password");
  
      const payload = { id: user._id, email: user.email, role: user.role }; 
      const token = jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: "1h" });

      res.cookie("token", token, { httpOnly: true, secure: true });
  
      res.status(200).json({ token });
    } catch (error) {
      console.error(error.message);
      res.status(500).send("Server Error");
    }
  };

//   Logging out
export const logout = async (req, res) => {
    res.clearCookie("token");
    
    res.status(200).send("Logout Successful");
  };
    
// Deleting user account
export const deleteAccount = async (req, res) => {
    try {
      const { email, password } = req.body;

      const user = await User.findOne({ email });
      if (!user) return res.status(404).send("User not found");
      const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) return res.status(401).send("Invalid credentials");
  
      await User.findByIdAndDelete(user._id);
      res.clearCookie("token");
      res.status(200).send("Account deleted successfully");
    } catch (error) {
      console.error(error.message);
      res.status(500).send("Server Error");
    }
  };
  

// Access auth users only
export const userEvent = (req, res) => {
    let events = [
        {
            "_id": "1",
            "name": "Auto Expo",
            "description": "lorem ipsum",
            "date": "2012-04-23T18:25:43.511Z"
        },
        {
            "_id": "2",
            "name": "Auto Expo",
            "description": "lorem ipsum",
            "date": "2012-04-23T18:25:43.511Z"
        },
        {
            "_id": "3",
            "name": "Auto Expo",
            "description": "lorem ipsum",
            "date": "2012-04-23T18:25:43.511Z"
        }
    ]
    res.json(events)
};

export const adminEvent = (req, res) => {
    let specialEvents = [
        {
            "_id": "1",
            "name": "Auto Expo Special",
            "description": "lorem ipsum",
            "date": "2012-04-23T18:25:43.511Z"
        },
        {
            "_id": "2",
            "name": "Auto Expo Special",
            "description": "lorem ipsum",
            "date": "2012-04-23T18:25:43.511Z"
        },
        {
            "_id": "3",
            "name": "Auto Expo Special",
            "description": "lorem ipsum",
            "date": "2012-04-23T18:25:43.511Z"
        },
        {
            "_id": "4",
            "name": "Auto Expo Special",
            "description": "lorem ipsum",
            "date": "2012-04-23T18:25:43.511Z"
        },
        {
            "_id": "5",
            "name": "Auto Expo Special",
            "description": "lorem ipsum",
            "date": "2012-04-23T18:25:43.511Z"
        },
        {
            "_id": "6",
            "name": "Auto Expo Special",
            "description": "lorem ipsum",
            "date": "2012-04-23T18:25:43.511Z"
        }
    ]
    res.json(specialEvents)

}