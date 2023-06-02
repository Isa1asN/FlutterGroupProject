import Vocabulary from "../models/vocabulary.js";

export const createVocabulary = async (req, res) => {
    try {
      const userId = req.user.id
        const {
            word,
            category,
            meaning, 
            description,
            localId
        } = req.body;
        
        const newVocab = new Vocabulary({
            word,
            category,
            meaning,
            description,
            createdById : userId,
            localId
        })

        const savedVocab = await newVocab.save();
        console.log("saved vocabs    ----",savedVocab)
        res.status(201).json({vocab : savedVocab});
    } catch (err) {
        res.status(500).json({error: err.message});
    }
}

export const getVocabularies = async (req, res) => {
    try {
        const userId = req.user.id
      const vocabularies = await Vocabulary.find({
        createdById:userId
      });
      console.log("sent u the vocabs..................")
      console.log(vocabularies)
      res.json({ vocabs:vocabularies });
    } catch (error) {
      console.log(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };

  export const editVocab = async (req, res) => {
    try {
      const userId = req.user.id;
      
      const {localId, word,category,meaning, description } = req.body;
      // console.log(userId,word)
      const updatedVocab = await Vocabulary.findOneAndUpdate(
        { localId: localId, createdById: userId },
        { word,category, meaning, description },
        { new: true }
      );
  
      if (!updatedVocab) {
        return res.status(404).json({ error: 'Vocabulary not found' });
      }
      console.log("updated vocab...",updatedVocab)
      res.json({ vocab: updatedVocab });
    } catch (error) {
      console.log(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };


  export const deleteVocab = async (req, res) => {
    try {
      const userId = req.user.id;
      const {localId} = req.params
      const updatedVocab = await Vocabulary.findOneAndDelete(
        { localId: localId, createdById: userId },
        { new: true }
      );
  
      if (!updatedVocab) {
        return res.status(404).json({ error: 'Vocabulary not found' });
      }
      console.log("vocab deleted.........")
      res.json({ vocab: updatedVocab });
    } catch (error) {
      console.log(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };

  export const editAllVocabs= async (req, res)=>{
      const {vocabs}=req.body
      console.log("these",vocabs)
      
      const userId = req.user.id;
      for(var vocab of vocabs){
        const {localId, word,category,meaning, description } = JSON.parse(vocab);
        console.log(vocab)
        try {
                  const updatedVocab = await Vocabulary.findOneAndUpdate(
                { localId: localId, createdById: userId },
                { word,category, meaning, description },
                { new: true }
              );
          
              if (!updatedVocab) {
                const newVocab = new Vocabulary({
                  word,
                  category,
                  meaning,
                  description,
                  createdById : userId,
                  localId
              })
              await newVocab.save()
              }
              console.log("updated all-------------------------------")
        } catch (error) {
          console.log(error);
          res.status(500).json({ error: 'Internal Server Error' });
        }
      }


      console.log("Updated a list of vocabs")
  }