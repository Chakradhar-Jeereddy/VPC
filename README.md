# AWS VPC Setup Steps

1. **Create VPC** with CIDR `10.0.0.0/16`

2. **Create Internet Gateway** and attach it to the VPC.

3. **Create Public Subnets** `1a` and `1b`:

   * `10.0.1.0/24`
   * `10.0.2.0/24`

4. **Create Private Subnets** `1c` and `1d`:

   * `10.0.11.0/24`
   * `10.0.12.0/24`

5. **Create Public Route Table** and associate it with the public subnets. Add a route to the **Internet Gateway**.

6. **Create Elastic IP** for the NAT Gateway.

7. **Create NAT Gateway** in a public subnet and associate it with the private subnet through the private route table.

8. **Associate the Elastic IP** with the NAT Gateway.


                    Internet
                       ↑
                       ↓
               Internet Gateway
                       ↑
                       ↓
              Public Subnet (1a)
                       │
                 NAT Gateway
                 + Elastic IP
                       ↑
                       │
              Private Route Table
             0.0.0.0/0 → NAT Gateway
                       ↑
                       │
              Private Subnet (1c)

   The key point is: **a NAT Gateway sits in a public subnet, but the private subnet uses a route table that points to the NAT Gateway.**

### NAT route-table setup

```text
                    Internet
                       ↑
                       ↓
               Internet Gateway
                       ↑
                       ↓
              Public Subnet (1a)
                       │
                 NAT Gateway
                 + Elastic IP
                       ↑
                       │
              Private Route Table
             0.0.0.0/0 → NAT Gateway
                       ↑
                       │
              Private Subnet (1c)
```

### Steps

1. **Create NAT Gateway** inside a **public subnet**.

2. **Attach an Elastic IP** to the NAT Gateway.

3. Create a **Private Route Table**.

4. Add this route:

```text
Destination: 0.0.0.0/0
Target:      NAT Gateway
```

5. Associate the **Private Route Table** with your private subnets.

### Important distinction

**Public route table:**

```text
0.0.0.0/0 → Internet Gateway
```

**Private route table:**

```text
0.0.0.0/0 → NAT Gateway
```

The traffic flow from a private EC2 instance is:

```text
Private EC2
    ↓
Private Route Table
    ↓
NAT Gateway
    ↓
Internet Gateway
    ↓
Internet
```

The NAT Gateway allows the **private instance to initiate outbound internet connections**, while the private instance does not need a public IP.

**Easy memory:**

> **Public subnet → IGW**
> **Private subnet → NAT Gateway → IGW**
