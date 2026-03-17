MPCManager Connection Flow - Explanation

1. Initialization
- Both devices initialize MPCManager.
- Each device sets its role:
  Sender (#) or Receiver (@).

2. Service Configuration
- configService() is called.
- PeerID is created using user name + role suffix.
- Session (MCSession) is initialized.

3. Discovery Phase
Receiver:
- Starts browsing using startBrowsingForPeers()

Sender:
- Starts advertising using startAdvertisingPeer()

4. Peer Detection
- Receiver finds available sender.
- browser(_:foundPeer:) is triggered.

5. Invitation
- Receiver sends invitation using invitePeer().
- Sender receives invitation via advertiser delegate.
- Invitation is accepted automatically.

6. Connection Established
- MCSession state changes to .connected.
- Both peers are now connected.

7. Initial Data Exchange
- Sender automatically sends initial media (if available).
- Receiver processes incoming data.

8. Data Communication
- Both peers can send/receive data using:
  sendData(data:peerId:)
- Delegate methods handle received data.

9. User Management
- Receiver stores connected users.
- Unique users are maintained in a list.
- Delegate notifies UI with updated user list.

10. Disconnection Handling
- If connection drops:
  - state becomes .notConnected
  - Auto-reconnect triggers after 2 seconds

11. Restart Flow
- restartPeering():
  - Stops current session
  - Reconfigures service
  - Starts discovery again

12. Stop Services
- stopAllServices():
  - Stops browsing/advertising
  - Disconnects session
  - Clears peers

Summary:
- Receiver = discovers & connects
- Sender = advertises & shares data
- Communication = bidirectional after connection

MPCManager Connection Flow Diagram

[Receiver (@)]                          [Sender (#)]
      |                                       |
      |--- startBrowsingForPeers() ---------->|
      |                                       |
      |<------ advertisePeer() ---------------|
      |                                       |
      |--- invitePeer() --------------------->|
      |                                       |
      |<------ accept invitation -------------|
      |                                       |
      |======== Connection Established =======|
      |                                       |
      |<------ send initial media ------------|
      |                                       |
      |--- sendData() / receiveData() <------>|
      |                                       |
      |======== Data Exchange Ongoing ========|
      |                                       |
      |--- disconnect / lost connection ------|
      |                                       |
      |--- auto restart (after 2 sec) --------|

