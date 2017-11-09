#include <list>
#include <string>
#include <iostream>

class Node {
  public:
    std::string tag, value;
    std::list<Node> children;
	
	int id;
	static int nextId = -1;
	
    Node(std::string t, std::string v) : tag(t), value(v) {
		id = nextId++;
	}
	
    Node() { 
		tag="uninitialised";
		value="uninitialised";
		id = nextId++;
	}

    void dump(int depth=0)
    {
      for(int i=0; i<depth; i++)
        std::cout << " ";
      std::cout << tag << ":" << value << std::endl;
      for(auto i=children.begin(); i!=children.end(); i++)
        (*i).dump(depth+1);
    }
    
    void dumps_dot(std::ostream& stream, int depth=0) {
		if (depth == 0){
			stream << "digraph parsetree {" << std::endl;
			stream << "    size=\"6,6\";" << std::endl;
			//stream << "    node [color=lightblue2, style=filled];" << std::endl;
		}

		for(std::list<Node>::iterator i=children.begin(); i!=children.end(); i++){
			for(int si=0; si<depth+4; si++)
		    	stream << " ";
		    stream << '"' << id + "[label=\"" + tag + ':' + value + "]";
	 		stream << "\" -> \"";
			stream << (*i).tag + ':' + (*i).value;
		    stream << "\" ;" << std::endl;
		}

		for(std::list<Node>::iterator i=children.begin(); i!=children.end(); i++)
		    (*i).dumps_dot(stream, depth+1);
	
		if (depth == 0){
			stream << "}" << std::endl;
		}
	}
};
