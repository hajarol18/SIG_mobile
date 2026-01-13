import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/construction.dart';

class ConstructionCard extends StatelessWidget {
  final Construction construction;
  final VoidCallback? onTap;
  final VoidCallback? onMapTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ConstructionCard({
    super.key,
    required this.construction,
    this.onTap,
    this.onMapTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Indicateur de couleur par type
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(construction.type.colorValue).withOpacity(0.3),
                  border: Border.all(
                    color: Color(construction.type.colorValue),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconForType(construction.type),
                  color: Color(construction.type.colorValue),
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              // Informations principales
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      construction.adresse,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(construction.type.colorValue)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            construction.type.label,
                            style: TextStyle(
                              color: Color(construction.type.colorValue),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (construction.contact != null) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.phone,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            construction.contact!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd/MM/yyyy à HH:mm').format(
                        construction.dateCreation,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              // Actions
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onMapTap != null)
                    IconButton(
                      icon: const Icon(Icons.map),
                      color: Colors.blue,
                      onPressed: onMapTap,
                      tooltip: 'Voir sur la carte',
                    ),
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color: Colors.orange,
                      onPressed: onEdit,
                      tooltip: 'Modifier',
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: onDelete,
                      tooltip: 'Supprimer',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(ConstructionType type) {
    switch (type) {
      case ConstructionType.residentiel:
        return Icons.home;
      case ConstructionType.commercial:
        return Icons.store;
      case ConstructionType.industriel:
        return Icons.factory;
      case ConstructionType.administratif:
        return Icons.business;
      case ConstructionType.educatif:
        return Icons.school;
      case ConstructionType.sanitaire:
        return Icons.local_hospital;
      case ConstructionType.autre:
        return Icons.location_city;
    }
  }
}
