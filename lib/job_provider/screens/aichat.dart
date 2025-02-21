import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'dart:developer';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  AiChatPageState createState() => AiChatPageState();
}

class AiChatPageState extends State<AiChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _chatHistory = [];
  bool _isLoading = false;

  List<Map<String, dynamic>>? usersPosts;

  @override
  void initState() {
    super.initState();
  }

  final instructions = '''
"instruction"={"system_prompt"  : "Your name is your AI Assistant . your aim is to assist the user for the user_input . this is the system instruction and i provide app details in app_details. you can understand the app details from there. you must give reply to the user_input." , "app_details": " you are to assist job provider to estimate the cost and worker numbers. You should give only a brief points of total cost and its individual costs. and total numvber of workers requiredMasonry Work

Masonry is a critical component of construction and involves building structures from individual units such as bricks, stones, or concrete blocks. These units are bound together with mortar. The job requires precision, expertise, and teamwork to ensure a durable and aesthetically pleasing outcome. This detailed guide will cover material estimation, worker estimation, time estimation, and salary estimation for masonry work.


---

1. Material Estimation

Masonry work relies heavily on accurate material calculations to minimize waste and reduce costs. Here's how the key materials are estimated:

A. Bricks

Bricks are the primary building unit in masonry. For a single wall of 100 sq. ft, approximately 500 standard bricks are required. This calculation considers the standard size of a brick (7.5 x 3.5 x 2.75 inches) and a 10mm mortar joint.

For multi-layered walls or complex structures, the quantity increases proportionally.


B. Cement

Cement is mixed with sand to create mortar, which binds the bricks together.

For 100 sq. ft of a standard 9-inch thick brick wall:

Cement: 1 bag (50 kg) per 35 sq. ft of wall area.

For 100 sq. ft, approximately 3 bags of cement are required.



C. Sand

Sand is mixed with cement in varying proportions depending on the type of masonry.

For general masonry, a 1:6 cement-to-sand ratio is used.

For 100 sq. ft of wall, approximately 0.3 cubic meters of sand are required.



D. Water

Clean water is essential for mixing mortar and curing. About 30-50 liters of water are needed per 100 sq. ft.


E. Additional Materials

Scaffolding: Temporary structures for elevation. Costs depend on the project size.

Reinforcements: Steel rods may be required for load-bearing walls.



---

2. Worker Estimation

Masonry work is labor-intensive and requires skilled and unskilled workers:

A. Skilled Workers (Masons)

A mason is responsible for placing bricks, mixing mortar, and ensuring the wall is level and aligned.

Productivity: 1 mason can construct 150 sq. ft of wall per day.


B. Unskilled Workers (Helpers)

Helpers assist by mixing mortar, bringing materials, and cleaning tools.

Productivity: 1 helper can assist a mason efficiently.


Team Structure

For a 300 sq. ft wall:

Masons: 2

Helpers: 2




---

3. Time Estimation

A. Productivity Metrics

The time required depends on the complexity of the structure, weather conditions, and worker efficiency.

Example:

1 mason can complete 150 sq. ft/day.

For a 300 sq. ft wall, 2 masons can complete the task in 1 day.



B. Factors Influencing Time

Curing Time: Mortar needs curing to gain strength, typically 7 days.

Weather Conditions: Rain can delay work.

Design Complexity: Ornamental masonry takes longer than standard wall construction.



---

4. Salary Estimation

Wages for masons and helpers vary based on location, skill level, and project type.

A. Daily Wages

Skilled Mason: ₹800 - ₹1,200/day.

Helper: ₹500 - ₹700/day.


B. Project Cost Breakdown

For a 300 sq. ft wall:

Masons: 2 × ₹800 × 1 day = ₹1,600.

Helpers: 2 × ₹500 × 1 day = ₹1,000.

Total Labor Cost: ₹2,600.



C. Additional Costs

Scaffolding: ₹1,000/day for small projects.

Miscellaneous: ₹500 for tools and safety gear.



---

5. Challenges in Masonry Work

A. Material Quality

Substandard bricks or sand can weaken the structure.

Quality checks are necessary for durability.


B. Skill Levels

An inexperienced mason may cause uneven walls or waste materials.


C. Safety Concerns

Proper safety measures, such as helmets and gloves, are essential.



---

6. Case Study: Building a Compound Wall

Imagine constructing a 300 sq. ft compound wall with a height of 6 feet.

Material Estimation:

Bricks: 1,500 units.

Cement: 9 bags (3 bags per 100 sq. ft).

Sand: 1 cubic meter.


Worker Requirement:

Masons: 2

Helpers: 2


Time Estimation:

2 days (150 sq. ft/day per mason).


Salary Estimation:

Total labor cost: ₹5,200 (for 2 days).

Material cost: Approximately ₹25,000 (depending on local rates).

Total project cost: ₹30,200.



---

7. Tools and Techniques

A. Tools

Trowels, hammers, and spirit levels are essential for precision.

Measuring tapes and string lines ensure alignment.


B. Techniques

Running Bond: A popular pattern for strength and stability.

English Bond: Alternates layers of stretcher and header bricks.



---

8. Sustainable Practices

A. Eco-Friendly Materials

Use fly ash bricks to reduce environmental impact.


B. Waste Management

Reuse leftover mortar and broken bricks for filling purposes.
Painting Work

Painting is a fundamental aspect of construction and maintenance that enhances the aesthetic appeal and durability of buildings. It involves surface preparation, material selection, and the application of paints and finishes. Below is a detailed breakdown of material estimation, worker estimation, time estimation, and salary estimation for painting work.


---

1. Material Estimation

Accurate estimation of materials is crucial to ensure quality and minimize waste.

A. Paint

The primary material required is paint. Paint consumption is generally calculated based on the area to be painted and the number of coats.

Formula:

Coverage per liter (single coat) = 100-120 sq. ft.

For double coats, the total area is doubled.

Example: For a 500 sq. ft wall requiring two coats:

Paint needed = (500 × 2) ÷ 100 = 10 liters.




B. Primer

Primer is used to prepare the surface and improve paint adhesion.

Estimate: Approximately 10% of the total paint volume.

Example: If 10 liters of paint are needed, 1 liter of primer will suffice.


C. Putty

Putty is applied to smooth out wall imperfections before painting.

Estimation: 1 kg of putty for 10 sq. ft.

For a 500 sq. ft wall: 50 kg of putty.


D. Tools

Brushes and Rollers: 2-3 sets for medium-sized projects.

Other Materials: Sandpaper (5-10 sheets), masking tape, and cleaning solvents.



---

2. Worker Estimation

The number of workers required depends on the scale of the job and the type of surface being painted.

A. Skilled Workers (Painters)

A skilled painter is responsible for applying paint evenly, ensuring clean edges, and maintaining consistency.

Productivity: A painter can cover 200 sq. ft/day (single coat).


B. Unskilled Workers (Helpers)

Helpers assist with tasks like surface preparation, moving equipment, and cleaning.

Productivity: 1 helper can support 2 painters efficiently.


Team Structure

For a 500 sq. ft wall requiring two coats:

Painters: 1

Helpers: 1




---

3. Time Estimation

The time required for painting depends on the area, surface condition, and type of paint.

A. General Productivity Metrics

Single-coat coverage: 200 sq. ft/day/painter.

Double-coat coverage: 100 sq. ft/day/painter.


B. Steps Involved

1. Surface Preparation: Cleaning, sanding, and applying putty (1-2 days).


2. Primer Application: Takes 1 day for 500 sq. ft.


3. Paint Application: 2-3 days for two coats on a 500 sq. ft surface.



Total Time Estimation: 4-6 days for a medium-sized project.


---

4. Salary Estimation

Wages for painters and helpers depend on their experience, location, and the project complexity.

A. Daily Wages

Skilled Painter: ₹700 - ₹1,000/day.

Helper: ₹500 - ₹700/day.


B. Total Labor Cost

For a 500 sq. ft wall requiring 6 days:

Painter: ₹700 × 6 = ₹4,200.

Helper: ₹500 × 6 = ₹3,000.

Total Labor Cost: ₹7,200.




---

5. Process of Painting

The painting process involves multiple stages to ensure a professional finish.

A. Surface Preparation

Remove dust, grease, and loose paint using sandpaper or chemical solutions.

Repair cracks and holes using putty or filler.

Allow the surface to dry completely before proceeding.


B. Primer Application

Apply primer evenly to improve paint adhesion and enhance the final appearance.

Let it dry for 6-8 hours before applying paint.


C. Paint Application

Use brushes for edges and corners, and rollers for large surfaces.

Apply the first coat, let it dry (4-6 hours), and then apply the second coat.


D. Final Finishing

Inspect the painted surface for any uneven areas or missed spots.

Perform touch-ups as required.



---

6. Material Cost Breakdown

Below is a cost estimate for a typical 500 sq. ft painting job:

Paint (10 liters): ₹4,000 (₹400/liter).

Primer (1 liter): ₹400.

Putty (50 kg): ₹2,500 (₹50/kg).

Tools and Miscellaneous: ₹1,000.

Total Material Cost: ₹7,900.



---

7. Challenges in Painting Work

A. Material Wastage

Excess paint and improper application tools can lead to wastage.


B. Weather Conditions

High humidity can delay drying times and affect the paint's finish.


C. Surface Conditions

Uneven or damp surfaces require extensive preparation, increasing time and cost.


D. Skilled Labor

Hiring unskilled painters can result in an uneven finish and excessive material usage.



---

8. Case Study: Painting a Living Room

Imagine painting a 15 ft × 15 ft living room with a ceiling height of 10 ft.

Step 1: Material Estimation

Wall Area: 2 × (15 × 10) + 2 × (15 × 10) = 600 sq. ft.

Ceiling Area: 15 × 15 = 225 sq. ft.

Total Area: 825 sq. ft.

Paint Required: (825 × 2 coats) ÷ 100 = 16.5 liters.


Step 2: Worker Requirement

1 painter and 1 helper.


Step 3: Time Estimation

2 days for surface preparation and primer.

3 days for painting.


Step 4: Cost Estimation

Labor Cost: ₹700 (painter) × 5 days + ₹500 (helper) × 5 days = ₹6,000.

Material Cost: Paint, primer, putty, and tools = ₹12,500.

Total Cost: ₹18,500.



---

9. Eco-Friendly Painting

Sustainability is becoming a priority in the painting industry. Eco-friendly options include:

Low-VOC Paints: Reduce harmful emissions and improve indoor air quality.

Water-Based Paints: Easier to clean and less harmful to the environment.

Recycled Paints: Made from leftover paints, reducing waste.



---

10. Modern Techniques and Tools

Advancements in technology have improved painting efficiency:

Spray Painting: Covers large areas quickly with a uniform finish.

Digital Color Matching: Helps in selecting the exact color shade.

Texture Rollers: Add patterns to walls for decorative purposes.

Here’s a 1000-word detailed explanation of Plumbing Work, covering material estimation, worker estimation, time estimation, and salary estimation.


---

Plumbing Work

Plumbing work is a critical aspect of construction and maintenance, focusing on the installation, repair, and maintenance of systems that involve water supply, drainage, and gas pipelines. It ensures safe and efficient water flow, waste disposal, and even heating systems in buildings. This guide offers a comprehensive breakdown of material estimation, worker estimation, time estimation, and salary estimation for plumbing work.


---

1. Material Estimation

Accurate estimation of materials is essential to avoid shortages or excess costs. Plumbing materials depend on the scope and type of work, such as residential installations or industrial projects.

A. Pipes

Pipes are the backbone of plumbing systems. Their type and quantity depend on the purpose (e.g., water supply or drainage) and material (PVC, CPVC, or metal).

Example: For a 1,000 sq. ft house with two bathrooms and a kitchen:

Water Supply Pipes: 150-200 meters of CPVC pipes (1/2 inch and 3/4 inch diameter).

Drainage Pipes: 50-70 meters of PVC pipes (3-inch or 4-inch diameter).



B. Fittings and Connectors

These include elbows, tees, couplings, and unions to join and route pipes.

Estimate: Approximately 10 connectors per 10 meters of piping.


C. Valves

Valves control water flow and are crucial for maintenance.

Example: 5-10 valves for a standard house.


D. Fixtures

Fixtures like faucets, sinks, showerheads, and toilets are essential in plumbing installations.

Example: A standard house may require:

Faucets: 6-8 units.

Sinks: 2-3 units.

Showerheads: 2 units.

Toilets: 2-3 units.



E. Other Materials

Adhesives (for PVC/CPVC pipes), Teflon tape, clamps, and insulation material.

Water storage tank: 1,000-liter capacity for a standard house.



---

2. Worker Estimation

The workforce required for plumbing work varies depending on the

Here’s a comprehensive 1000-word note about Plumbing Work, covering material estimation, worker estimation, time estimation, and salary estimation.


---

Plumbing Work

Plumbing work is essential for installing and maintaining systems for water supply, drainage, and sometimes gas distribution. It includes tasks such as fitting pipes, installing fixtures, and maintaining heating or cooling systems. This guide provides a detailed breakdown of materials, labor, time, and cost for plumbing projects.


---

1. Material Estimation

Plumbing requires various materials depending on the project scope, building size, and type of system (water, drainage, or gas). Below is an estimation strategy:

A. Pipes and Tubes
Pipes are the primary material for plumbing, varying by use:

Types: PVC, CPVC, GI (Galvanized Iron), PEX, and copper pipes.

Estimation Formula: Length = (Number of fixtures × Average distance to the water source).

Example: For a 1,000 sq. ft house with two bathrooms and a kitchen:

Coldwater Supply (CPVC): 150 meters.

Hotwater Supply (CPVC/PEX): 50 meters.

Drainage (PVC): 80 meters.



B. Fittings
Fittings connect and direct pipe flows:

Types: Elbows, tees, couplings, reducers, and caps.

Estimation: 10 fittings for every 15 meters of pipe.

Example: 20-30 fittings for 150 meters of pipes.


C. Fixtures
Fixtures are essential for water access and disposal:

Examples: Faucets, sinks, showers, toilets, and taps.

Estimation:

Kitchen Sink: 1 unit.

Wash Basin: 2-3 units.

Showerheads: 2 units.

Toilets: 2-3 units.



D. Valves and Accessories
Valves control flow and are crucial for maintenance:

Gate valves, ball valves, and pressure-reducing valves.

Example: 10 valves for a house with two bathrooms.


E. Adhesives and Sealants
PVC adhesive, Teflon tape, and pipe clamps are used for joint sealing.

Example: 1 liter of adhesive and 5 rolls of Teflon tape for 150 meters of pipes.


F. Water Tank and Pump
A storage tank and water pump are integral for consistent water supply.

Example: 1,000-liter tank and a 1 HP pump for a 1,000 sq. ft house.



---

2. Worker Estimation

The number of workers required depends on the scale and complexity of the project.

A. Skilled Plumbers
Skilled plumbers handle installations, troubleshooting, and repairs:

Workload: A skilled plumber can install 20-25 meters of piping per day.


B. Unskilled Workers
Unskilled labor supports skilled plumbers with material handling, digging, and basic assembly.

Workload: 1 unskilled worker can assist 2 skilled plumbers.


Team Structure:
For a 1,000 sq. ft house:

Skilled Plumbers: 2

Unskilled Workers: 1



---

3. Time Estimation

Time required for plumbing depends on the building size, number of fixtures, and system complexity.

A. General Productivity Metrics

Pipe Installation: 20-25 meters/day/plumber.

Fixture Installation: 2-3 fixtures/day/plumber.


B. Breakdown of Activities

1. Planning and Layout: 1-2 days.

Measuring distances, determining pipe routes, and marking positions for fixtures.



2. Pipe Installation:

150 meters at 25 meters/day = 6 days for 2 plumbers.



3. Fixture Installation:

8 fixtures at 3 fixtures/day = 2-3 days.



4. Testing and Adjustments: 1-2 days.



Total Time Estimate: 10-12 days for a 1,000 sq. ft house.


---

4. Salary Estimation

Labor costs depend on regional wage rates and worker experience.

A. Daily Wages

Skilled Plumbers: ₹800 - ₹1,200/day.

Unskilled Workers: ₹500 - ₹700/day.


B. Total Labor Cost
For a 10-day project with a team of 2 plumbers and 1 helper:

Plumbers: ₹1,000 × 10 × 2 = ₹20,000.

Helper: ₹600 × 10 = ₹6,000.

Total Salary Cost: ₹26,000.



---

5. Process of Plumbing

Plumbing involves multiple stages to ensure functionality and safety.

A. Planning and Design

Identify water supply and drainage points.

Create a detailed layout showing pipe routes and fixture positions.


B. Surface Preparation

Excavate trenches or drill walls for pipe installation.

Remove debris and clean surfaces to ensure proper joint sealing.


C. Pipe Installation

Cut pipes to the required length.

Connect pipes using fittings and adhesive.

Secure pipes with clamps to prevent movement.


D. Fixture Installation

Install sinks, taps, and other fixtures at marked positions.

Connect fixtures to supply and drainage systems.


E. Testing and Inspection

Check for leaks and blockages by running water through the system.

Make necessary adjustments to ensure efficiency.



---

6. Material Cost Breakdown

For a 1,000 sq. ft house, the estimated costs are:

Pipes (PVC, CPVC): ₹15,000.

Fittings: ₹5,000.

Fixtures: ₹20,000.

Valves and Adhesives: ₹3,000.

Water Tank and Pump: ₹12,000.

Miscellaneous: ₹5,000.

Total Material Cost: ₹60,000.



---

7. Challenges in Plumbing Work

Plumbing projects may face challenges such as:

1. Leakage Issues: Poor joint sealing or material defects can lead to leaks.


2. Blockages: Improper pipe gradients or foreign objects in drains.


3. Corrosion: Metal pipes are prone to rust in humid environments.


4. Water Pressure Problems: Inadequate pipe diameter or faulty pumps can cause low pressure.


5. Accessibility Issues: Narrow spaces or concealed pipes increase project complexity.




---

8. Eco-Friendly Plumbing Solutions

Modern plumbing emphasizes sustainability:

Low-Flow Fixtures: Reduce water consumption.

Rainwater Harvesting: Utilize collected rainwater for non-potable purposes.

Greywater Recycling: Reuse wastewater from sinks and showers for irrigation.

PVC Alternatives: Use recyclable materials like HDPE pipes.



---

9. Case Study: Plumbing a Residential Building

Scenario: Plumbing work for a 1,000 sq. ft house with two bathrooms, a kitchen, and a water tank.

Step 1: Material Estimation

Pipes: 200 meters (₹15,000).

Fixtures: Faucets, toilets, and sinks (₹20,000).

Total Material Cost: ₹60,000.


Step 2: Worker Requirement

2 skilled plumbers and 1 helper.


Step 3: Time Estimation

Planning and preparation: 2 days.

Pipe installation: 6 days.

Fixture installation: 3 days.

Total Time: 11 days.


Step 4: Cost Estimation

Labor Cost: ₹26,000.

Material Cost: ₹60,000.

Total Cost: ₹86,000.



---

10. Future Trends in Plumbing

Plumbing is evolving with technology and sustainability goals:

Smart Plumbing: Systems that detect leaks and monitor water usage via IoT devices.

Pre-Fabricated Plumbing Systems: Reduces installation time and labor costs.

Green Building Certifications: Encourages eco-friendly practices in plumbing design.



---

This detailed note on plumbing covers every aspect of the job. Let me know which job to cover next!"}''';

  void _sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    setState(() {
      _chatHistory.add({'role': 'user', 'message': userMessage});
      _isLoading = true;
    });

    String modifiedUserInput =
        '''$instructions,  "user_input": "$userMessage"''';

    try {
      final gemini = Gemini.instance;

      final conversation = [
        ..._chatHistory.map(
          (msg) => Content(
            parts: [Part.text(msg['message']!)],
            role: msg['role'],
          ),
        ),
        Content(
          parts: [Part.text(modifiedUserInput)],
          role: 'user',
        ),
      ];
      final response = await gemini.chat(conversation);
      if (mounted) {
        setState(() {
          _chatHistory.add({
            'role': 'model',
            'message': response?.output ?? 'No response received',
          });
        });
      }
    } catch (e) {
      log('Error in chat: $e');
      if (mounted) {
        setState(() {
          _chatHistory.add({
            'role': 'error',
            'message':
                'Response not loading. Please try again or check your internet connection.',
          });
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildMessageBubble(String message, String role,
      {bool isLoading = false}) {
    bool isUser = role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 18.0),
        decoration: BoxDecoration(
          color: isUser
              ? const Color.fromARGB(255, 48, 77, 159)
              : Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
            bottomLeft: isUser ? const Radius.circular(20.0) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 39, 36, 36).withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                message,
                style: TextStyle(
                  fontSize: 16.0,
                  color: isUser ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      itemCount: _chatHistory.length + (_isLoading ? 1 : 0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (context, index) {
        if (index == _chatHistory.length && _isLoading) {
          return _buildMessageBubble('', 'model', isLoading: true);
        }
        final message = _chatHistory[index];
        return _buildMessageBubble(message['message']!, message['role']!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 137, 157, 165),
                Color.fromARGB(255, 191, 160, 158),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 0.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('asset/pic01.jpg'),
                backgroundColor: Colors.blue,
                radius: 25,
              ),
              SizedBox(width: 10),
              Text(
                'Fix AI',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 131, 167, 182),
              Color.fromARGB(255, 198, 152, 152)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _chatHistory.isEmpty
                    ? const Center(
                        child: Text(
                          'Start a conversation with Fix Ai',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 43, 40, 40)),
                        ),
                      )
                    : _buildChatList(),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 152, 144, 144),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                          minLines: 1,
                          maxLines: 5,
                          onSubmitted: (_) {
                            final message = _controller.text;
                            _controller.clear();
                            _sendMessage(message);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Color.fromARGB(255, 9, 36, 82),
                        ),
                        onPressed: () {
                          final message = _controller.text;
                          _controller.clear();
                          _sendMessage(message);
                        },
                        splashColor: Colors.blueAccent.withOpacity(0.3),
                        splashRadius: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
