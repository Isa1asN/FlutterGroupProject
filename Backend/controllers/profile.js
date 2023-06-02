import User from "../models/user.js";

// Profile view 
export const viewProfile = async (req, res) => {
    try {
      const { userId } = req.params;
      const idToken = req.user.id;
      if(userId == idToken){
        const user = await User.findById(userId);
        
      if (!user) {
        return res.status(404).json({ error: 'User not found' });
      }
      console.log(user)
      delete user.password
      return res.json({ user });
    }return res.status(404).json({ error: 'User not found' });
    } catch (error) {
      console.log(error);
      return res.status(500).json({ error: 'Internal Server Error' });
    }
  };
  
// Change email of the user
export const changeEmail = async (req, res) => {
    try {
      const { userId } = req.params;
      const { email } = req.body;
      const idToken = req.user.id;
      if(userId == idToken){
      const user = await User.findById(userId);
      if (!user) {
        return res.status(404).json({ error: 'User not found' });
      }
  
      user.email = email;
      await user.save();
  
      return res.status(201).json({ message: 'Email changed successfully', user });
    }return res.status(404).json({ error: 'User not found' });
    } catch (error) {
      console.log(error);
      return res.status(500).json({ error: 'Internal Server Error' });
    }
  };
  
  