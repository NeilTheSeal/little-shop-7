def define_instance_variables
  @merchant = create(:merchant)
  @customer_list = create_list(:customer, 6)

  @item_list = create_list(
    :item,
    21,
    merchant: @merchant,
    unit_price: 1000,
    status: "enabled"
  )

  @item_list2 = create_list(
    :item, 21,
    merchant: @merchant,
    unit_price: 1000,
    status: "disabled"
  )

  @invoice_list = []

  @invoice_list << create(
    :invoice,
    customer: @customer_list[0],
    created_at: "2022-01-01 00:00:00"
  )

  2.times do
    @invoice_list << create(
      :invoice,
      customer: @customer_list[1],
      created_at: "2021-01-01 00:00:00"
    )
  end

  3.times { @invoice_list << create(:invoice, customer: @customer_list[2]) }
  4.times { @invoice_list << create(:invoice, customer: @customer_list[3]) }
  5.times { @invoice_list << create(:invoice, customer: @customer_list[4]) }
  6.times { @invoice_list << create(:invoice, customer: @customer_list[5]) }

  @invoice_item_list = []
  @item_list.each_with_index do |item, index|
    @invoice_item_list << if index < 10
                            create(
                              :invoice_item,
                              item:,
                              invoice: @invoice_list[index],
                              unit_price: item.unit_price,
                              status: "packaged"
                            )
                          elsif index < 15
                            create(
                              :invoice_item,
                              item:,
                              invoice: @invoice_list[index],
                              unit_price: item.unit_price,
                              status: "pending"
                            )
                          else
                            create(
                              :invoice_item,
                              item:,
                              invoice: @invoice_list[index],
                              unit_price: item.unit_price,
                              status: "shipped"
                            )
                          end
  end
  @transaction_list = []
  @invoice_list.each do |invoice|
    @transaction_list << create(:transaction, invoice:)
  end
end
